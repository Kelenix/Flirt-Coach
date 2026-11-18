// Événements d'achat RevenueCat → actions sur les crédits et les droits Premium.
// Logique pure, testée sans réseau. Format : docs RevenueCat « Event Types and Fields ».

/** Abonnements Premium (mêmes droits pour les trois durées, INTAKE §3.1). */
export const subscriptionProducts: ReadonlySet<string> = new Set([
  "flirtcoach_premium_weekly",
  "flirtcoach_premium_monthly",
  "flirtcoach_premium_annual",
]);

/** Packs de crédits (INTAKE §3.2) : le nombre de crédits est fixé ici, jamais par l'app. */
export const creditPacks: Readonly<Record<string, number>> = {
  flirtcoach_credits_20: 20,
  flirtcoach_credits_50: 50,
  flirtcoach_credits_100: 100,
};

export type WebhookAction =
  | { kind: "grant_credits"; userId: string; amount: number; reference: string }
  | { kind: "revoke_credits"; userId: string; amount: number; reference: string }
  | {
    kind: "set_premium";
    userId: string;
    isPremium: boolean;
    product: string;
    expiresAt: string | null;
    force: boolean;
  }
  | { kind: "ignore"; reason: string };

const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

/** Google Play nomme les abonnements « produit:formule » ; on ne garde que le produit. */
export function baseProductId(productId: string): string {
  return productId.split(":")[0];
}

/** L'app s'identifie auprès de RevenueCat avec l'identifiant Supabase de l'utilisateur. */
export function resolveUserId(event: Record<string, unknown>): string | null {
  const candidates = [
    event.app_user_id,
    event.original_app_user_id,
    ...(Array.isArray(event.aliases) ? event.aliases : []),
  ];
  for (const candidate of candidates) {
    if (typeof candidate === "string" && uuidPattern.test(candidate)) {
      return candidate.toLowerCase();
    }
  }
  return null;
}

const activatingEvents = new Set([
  "INITIAL_PURCHASE",
  "RENEWAL",
  "UNCANCELLATION",
  "PRODUCT_CHANGE",
  "SUBSCRIPTION_EXTENDED",
  "TEMPORARY_ENTITLEMENT_GRANT",
  "REFUND_REVERSED",
]);

export class MalformedEvent extends Error {}

export interface WebhookOptions {
  /** Achats de test (sandbox) acceptés : seulement pendant la phase de test. */
  allowSandbox: boolean;
}

export function actionFor(
  payload: unknown,
  options: WebhookOptions = { allowSandbox: false },
): WebhookAction {
  const event = (payload as { event?: unknown } | null)?.event;
  if (typeof event !== "object" || event === null) throw new MalformedEvent("event");
  const fields = event as Record<string, unknown>;
  const type = fields.type;
  if (typeof type !== "string") throw new MalformedEvent("type");
  if (type === "TEST") return { kind: "ignore", reason: "test" };
  // Un achat sandbox est gratuit : il ne doit jamais donner de vrais droits en production.
  if (fields.environment === "SANDBOX" && !options.allowSandbox) {
    return { kind: "ignore", reason: "sandbox" };
  }

  const userId = resolveUserId(fields);
  if (userId === null) return { kind: "ignore", reason: "unknown_user" };
  if (typeof fields.product_id !== "string") return { kind: "ignore", reason: "no_product" };
  const product = baseProductId(fields.product_id);
  const expiresAt = typeof fields.expiration_at_ms === "number"
    ? new Date(fields.expiration_at_ms).toISOString()
    : null;

  if (product in creditPacks) {
    const reference = fields.transaction_id ?? fields.id;
    if (typeof reference !== "string") throw new MalformedEvent("transaction_id");
    if (type === "NON_RENEWING_PURCHASE") {
      return { kind: "grant_credits", userId, amount: creditPacks[product], reference };
    }
    // Pack remboursé : les crédits restants sont repris (au plus le montant du pack).
    if (type === "CANCELLATION" && fields.cancel_reason === "CUSTOMER_SUPPORT") {
      return {
        kind: "revoke_credits",
        userId,
        amount: creditPacks[product],
        reference: `refund:${reference}`,
      };
    }
    return { kind: "ignore", reason: `pack_${type}` };
  }

  if (!subscriptionProducts.has(product)) return { kind: "ignore", reason: "unknown_product" };

  if (activatingEvents.has(type)) {
    return { kind: "set_premium", userId, isPremium: true, product, expiresAt, force: false };
  }
  if (type === "EXPIRATION") {
    return { kind: "set_premium", userId, isPremium: false, product, expiresAt, force: false };
  }
  // Remboursement : Premium retiré tout de suite. Simple résiliation : actif jusqu'à l'échéance.
  if (type === "CANCELLATION" && fields.cancel_reason === "CUSTOMER_SUPPORT") {
    return {
      kind: "set_premium",
      userId,
      isPremium: false,
      product,
      expiresAt: new Date().toISOString(),
      force: true,
    };
  }
  return { kind: "ignore", reason: type };
}

/** Compare le secret sans fuite de temps (l'en-tête est configuré dans RevenueCat). */
export function isAuthorized(header: string | null, secret: string): boolean {
  if (secret.length === 0 || header === null) return false;
  const expected = new TextEncoder().encode(`Bearer ${secret}`);
  const received = new TextEncoder().encode(header);
  if (expected.length !== received.length) return false;
  let difference = 0;
  for (let index = 0; index < expected.length; index++) {
    difference |= expected[index] ^ received[index];
  }
  return difference === 0;
}
