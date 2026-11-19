// Logique pure de « redeem-code » (ADR-031), testée sans réseau ni base.

/** Saisie acceptée : lettres et chiffres, espaces et tirets ignorés, casse indifférente. */
export function normalizeCode(value: unknown): string | null {
  if (typeof value !== "string") return null;
  const code = value.replace(/[\s-]/g, "").toUpperCase();
  return /^[A-Z0-9]{8,64}$/.test(code) ? code : null;
}

/** Empreinte SHA-256 en hexadécimal minuscule (format du secret REVIEW_ACCESS_CODE_SHA256). */
export async function sha256Hex(text: string): Promise<string> {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(text));
  return Array.from(new Uint8Array(digest), (byte) => byte.toString(16).padStart(2, "0")).join(
    "",
  );
}

/** Comparaison en temps constant : la durée ne révèle pas le début du bon code. */
export function sameHash(a: string, b: string): boolean {
  if (a.length !== b.length) return false;
  let difference = 0;
  for (let i = 0; i < a.length; i++) difference |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return difference === 0;
}

/** Réponse HTTP pour le résultat de `redeem_access_code`. */
export function replyFor(
  result: { status: string; expires_at: string | null } | undefined,
): { status: number; body: Record<string, unknown> } {
  switch (result?.status) {
    case "granted":
      return { status: 200, body: { granted: true, expires_at: result.expires_at } };
    case "invalid":
      return { status: 400, body: { error: "invalid_code" } };
    case "unavailable":
      return { status: 409, body: { error: "code_unavailable" } };
    case "rate_limited":
      return { status: 429, body: { error: "too_many_attempts" } };
    default:
      return { status: 500, body: { error: "unexpected" } };
  }
}
