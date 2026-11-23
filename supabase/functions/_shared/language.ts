// Langue de l'interface de l'app, envoyée avec chaque requête (champ `locale`, ADR-034).
// Logique pure, testée sans réseau.
import { InvalidRequest } from "./errors.ts";

/** Langue des versions de l'app antérieures à l'anglais, qui n'envoient pas `locale`. */
export const defaultLanguage = "fr";

/** Code ISO 639 seul (« fr », « en ») : aucun autre texte n'entre dans les consignes. */
const languageCode = /^[a-z]{2,3}$/;

/** Langue de l'interface lue dans le corps de la requête ; `fr` si absente. */
export function parseLanguage(body: unknown): string {
  if (typeof body !== "object" || body === null) return defaultLanguage;
  const { locale } = body as Record<string, unknown>;
  if (locale === undefined || locale === null) return defaultLanguage;
  if (typeof locale !== "string" || !languageCode.test(locale)) {
    throw new InvalidRequest("locale");
  }
  return locale;
}

/** Explication commune aux consignes système (préfixe stable, sans donnée variable). */
export const appLanguageGuide =
  `- « Langue de l'app » donne, en code ISO 639 (fr = français, en = anglais…), la langue de l'utilisateur de l'app : les textes qui s'adressent à lui sont écrits dans cette langue, en le tutoyant si c'est le français.`;

/** Ligne de la demande qui indique au modèle la langue de l'utilisateur. */
export function languageLine(language: string): string {
  return `\nLangue de l'app : ${language}.`;
}
