// Vérification des rappels serveur AdMob (SSV) pour les vidéos récompensées.
// Format : doc Google « Validate server-side verification (SSV) callbacks ».
// Logique pure (WebCrypto), testée sans réseau avec des clés générées.

export const verifierKeysUrl = "https://www.gstatic.com/admob/reward/verifier-keys.json";

export interface RewardCallback {
  /** Message signé : la chaîne de requête brute, jusqu'à `&signature=` exclu. */
  message: string;
  signature: Uint8Array;
  keyId: string;
  transactionId: string;
  userId: string;
  /** Partie numérique du bloc d'annonces qui a versé la récompense. */
  adUnit: string;
}

export class InvalidCallback extends Error {}

const uuidPattern = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function base64UrlDecode(value: string): Uint8Array {
  const base64 = value.replaceAll("-", "+").replaceAll("_", "/");
  const padded = base64 + "=".repeat((4 - base64.length % 4) % 4);
  return Uint8Array.from(atob(padded), (char) => char.charCodeAt(0));
}

/** Lit un rappel AdMob ; le message signé est pris tel quel dans l'URL, sans décodage. */
export function parseCallback(url: URL): RewardCallback {
  const query = url.search.startsWith("?") ? url.search.slice(1) : url.search;
  const signatureAt = query.indexOf("&signature=");
  if (signatureAt <= 0) throw new InvalidCallback("signature");
  const params = url.searchParams;
  const signature = params.get("signature");
  const keyId = params.get("key_id");
  const transactionId = params.get("transaction_id");
  const userId = params.get("user_id");
  const adUnit = params.get("ad_unit");
  if (!signature || !keyId || !transactionId || !adUnit) throw new InvalidCallback("params");
  if (!/^\d{1,20}$/.test(keyId)) throw new InvalidCallback("key_id");
  if (!userId || !uuidPattern.test(userId)) throw new InvalidCallback("user_id");
  try {
    return {
      message: query.slice(0, signatureAt),
      signature: base64UrlDecode(signature),
      keyId,
      transactionId,
      userId: userId.toLowerCase(),
      adUnit,
    };
  } catch {
    throw new InvalidCallback("signature");
  }
}

/** Signature ECDSA encodée en DER → format brut r‖s (64 octets) attendu par WebCrypto. */
export function derToRaw(der: Uint8Array): Uint8Array<ArrayBuffer> {
  const fail = () => new InvalidCallback("der");
  if (der[0] !== 0x30) throw fail();
  let offset = 2;
  const readInteger = () => {
    if (der[offset] !== 0x02) throw fail();
    const length = der[offset + 1];
    let value = der.slice(offset + 2, offset + 2 + length);
    offset += 2 + length;
    while (value.length > 32 && value[0] === 0) value = value.slice(1);
    if (value.length > 32) throw fail();
    const padded = new Uint8Array(32);
    padded.set(value, 32 - value.length);
    return padded;
  };
  const raw = new Uint8Array(64);
  raw.set(readInteger(), 0);
  raw.set(readInteger(), 32);
  return raw;
}

/** Clés publiques de Google, indexées par `keyId` (champ `base64` = SPKI DER). */
export async function importVerifierKeys(json: unknown): Promise<Map<string, CryptoKey>> {
  const keys = new Map<string, CryptoKey>();
  const list = (json as { keys?: unknown })?.keys;
  if (!Array.isArray(list)) return keys;
  for (const entry of list) {
    const { keyId, base64 } = entry as { keyId?: unknown; base64?: unknown };
    if ((typeof keyId !== "number" && typeof keyId !== "string") || typeof base64 !== "string") {
      continue;
    }
    const spki = Uint8Array.from(atob(base64), (char) => char.charCodeAt(0));
    keys.set(
      String(keyId),
      await crypto.subtle.importKey("spki", spki, { name: "ECDSA", namedCurve: "P-256" }, false, [
        "verify",
      ]),
    );
  }
  return keys;
}

export async function isSignatureValid(
  callback: RewardCallback,
  keys: Map<string, CryptoKey>,
): Promise<boolean> {
  const key = keys.get(callback.keyId);
  if (!key) return false;
  try {
    return await crypto.subtle.verify(
      { name: "ECDSA", hash: "SHA-256" },
      key,
      derToRaw(callback.signature),
      new TextEncoder().encode(callback.message),
    );
  } catch {
    return false;
  }
}

/**
 * Les clés de signature de Google sont communes à tous les éditeurs : seul un rappel
 * venant d'un de NOS blocs d'annonces (liste `ADMOB_AD_UNIT_IDS`) crédite. Liste vide :
 * aucun contrôle (développement uniquement).
 */
export function isAllowedAdUnit(adUnit: string, allowed: readonly string[]): boolean {
  return allowed.length === 0 || allowed.includes(adUnit);
}

/** `ADMOB_AD_UNIT_IDS` : identifiants séparés par des virgules (partie après « / »). */
export function parseAdUnitList(value: string | undefined): string[] {
  return (value ?? "").split(",").map((id) => id.trim().split("/").pop()!).filter(Boolean);
}
