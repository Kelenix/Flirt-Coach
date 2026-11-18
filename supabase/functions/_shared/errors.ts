// Types partagés par les Edge Functions IA (logique pure, sans dépendance).

export class InvalidRequest extends Error {}

export class InvalidModelOutput extends Error {}

/** L'entrée ne permet pas de répondre (ex. capture sans conversation lisible). */
export class UnusableInput extends Error {}

/** Sortie du modèle : un résultat exploitable, ou un refus motivé. */
export type ModelOutcome<Output> =
  | { refused: false; value: Output }
  | { refused: true; reason: string };

/** Texte facultatif : `null` si absent ou vide, erreur si trop long ou mal typé. */
export function optionalText(value: unknown, maxLength: number, field: string): string | null {
  if (value === undefined || value === null) return null;
  if (typeof value !== "string") throw new InvalidRequest(field);
  const trimmed = value.trim();
  if (trimmed.length > maxLength) throw new InvalidRequest(field);
  return trimmed.length === 0 ? null : trimmed;
}

/** Analyse le JSON du modèle ; toute sortie illisible est une erreur. */
export function parseJson(text: string): Record<string, unknown> {
  try {
    const data = JSON.parse(text);
    if (typeof data === "object" && data !== null) return data as Record<string, unknown>;
  } catch {
    // traité ci-dessous
  }
  throw new InvalidModelOutput("json");
}

/** Encadre une donnée utilisateur ; elle ne peut pas fermer sa propre balise. */
export function block(tag: string, content: string | null): string {
  if (content === null) return "";
  return `\n\n<${tag}>\n${content.replaceAll(`</${tag}>`, "")}\n</${tag}>`;
}

/**
 * Erreur base de données due à un utilisateur inconnu (compte supprimé) : clé étrangère
 * manquante, ou `unknown_user` levé par `lock_balance`. Les rappels RevenueCat et AdMob
 * concernant un compte supprimé sont alors ignorés au lieu d'être rejoués sans fin.
 */
export function isUnknownUser(error: { code?: string; message?: string }): boolean {
  return error.code === "23503" || error.message === "unknown_user";
}
