// Validation de la requête de génération (logique pure, testée sans réseau).
import { InvalidRequest, optionalText } from "../_shared/errors.ts";

/** Situations de génération (INTAKE §2.1). Valeurs de `generation_kind` en base. */
export const situations = [
  "reply",
  "opener",
  "flirt",
  "follow_up",
  "pre_date",
  "apology",
  "soft_breakup",
] as const;
export type Situation = (typeof situations)[number];

export const styles = [
  "classic",
  "funny",
  "romantic",
  "mysterious",
  "direct",
  "elegant",
  "playful_bold",
] as const;
export type Style = (typeof styles)[number];

/** Styles de base, gratuits (INTAKE §2.3) ; les autres exigent Premium. */
export const freeStyles: ReadonlySet<Style> = new Set(["classic"]);

export const maxMessageLength = 2000;
export const maxContextLength = 1000;

export interface GenerationRequest {
  situation: Situation;
  style: Style;
  /** Message reçu : obligatoire pour `reply`, absent sinon. */
  message: string | null;
  /** Ce que l'utilisateur précise sur la situation ; facultatif. */
  context: string | null;
}

function isOneOf<T extends string>(
  values: readonly T[],
  value: unknown,
): value is T {
  return typeof value === "string" && (values as readonly string[]).includes(value);
}

export function parseRequest(body: unknown): GenerationRequest {
  if (typeof body !== "object" || body === null) {
    throw new InvalidRequest("body");
  }
  const { situation, style, message, context } = body as Record<string, unknown>;
  if (!isOneOf(situations, situation)) throw new InvalidRequest("situation");
  if (!isOneOf(styles, style)) throw new InvalidRequest("style");

  const receivedMessage = optionalText(message, maxMessageLength, "message");
  if ((situation === "reply") !== (receivedMessage !== null)) {
    throw new InvalidRequest("message");
  }
  return {
    situation,
    style,
    message: receivedMessage,
    context: optionalText(context, maxContextLength, "context"),
  };
}

export function requiresPremium(style: Style): boolean {
  return !freeStyles.has(style);
}
