// Socle commun des Edge Functions qui appellent Claude.
// Ordre : authentifier → valider → vérifier âge et droits → réserver les crédits →
// appeler Claude → enregistrer. Tout échec après la réservation rembourse.
import Anthropic from "@anthropic-ai/sdk";
import { createClient } from "@supabase/supabase-js";

import { InvalidModelOutput, InvalidRequest, type ModelOutcome, UnusableInput } from "./errors.ts";
import { parseLanguage } from "./language.ts";

/** Contenu du message utilisateur : texte, ou blocs (image + texte). */
export type UserContent =
  | string
  | Array<Anthropic.Beta.Messages.BetaImageBlockParam | Anthropic.Beta.Messages.BetaTextBlockParam>;

const model = "claude-opus-5-5";

const anthropic = new Anthropic({
  apiKey: Deno.env.get("ANTHROPIC_API_KEY"),
  timeout: 25_000,
  maxRetries: 1,
});

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false } },
);

/** Ce qui distingue un point d'entrée IA des autres. */
export interface AiEndpoint<Request, Output> {
  /** Nom court, pour les journaux. */
  name: string;
  /** Valide le corps de la requête ; lève `InvalidRequest`. */
  parse(body: unknown): Request;
  requiresPremium(request: Request): boolean;
  /** Coût en crédits pour un utilisateur gratuit. */
  cost(request: Request): number;
  systemPrompt: string;
  /** Demande au modèle ; `language` : code ISO 639 de la langue de l'app (« fr », « en »). */
  userPrompt(request: Request, language: string): UserContent;
  outputSchema: Record<string, unknown>;
  /**
   * Interprète la sortie JSON du modèle ; lève `InvalidModelOutput`, ou
   * `UnusableInput` si l'entrée ne permet pas de répondre (capture illisible).
   */
  interpret(text: string): ModelOutcome<Output>;
  /** Ligne enregistrée dans `generations` (sans id ni utilisateur). */
  record(request: Request, output: Output): Record<string, unknown>;
  /** Corps de la réponse en cas de succès (le portefeuille est ajouté). */
  respond(id: string, output: Output): Record<string, unknown>;
}

type ErrorCode =
  | "unauthorized"
  | "age_not_confirmed"
  | "invalid_request"
  | "premium_required"
  | "insufficient_credits"
  | "daily_limit"
  | "rate_limited"
  | "unusable_input"
  | "ai_unavailable";

const errorStatus: Record<ErrorCode, number> = {
  unauthorized: 401,
  age_not_confirmed: 403,
  invalid_request: 400,
  premium_required: 403,
  insufficient_credits: 402,
  daily_limit: 429,
  rate_limited: 429,
  unusable_input: 422,
  ai_unavailable: 503,
};

interface SpentCredits {
  from_daily: number;
  from_bonus: number;
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

const fail = (code: ErrorCode) => json({ error: code }, errorStatus[code]);

async function authenticatedUserId(request: Request): Promise<string | null> {
  const token = request.headers.get("Authorization")?.replace(/^Bearer /, "");
  if (!token) return null;
  const { data, error } = await admin.auth.getUser(token);
  return error ? null : data.user.id;
}

async function isPremium(userId: string): Promise<boolean> {
  const { data } = await admin.rpc("is_premium", { p_user: userId });
  return data === true;
}

/** Portefeuille au même format que `get_wallet` côté app (source unique : `wallet_of`). */
async function fetchWallet(userId: string) {
  const { data, error } = await admin.rpc("wallet_of", { p_user: userId }).single();
  if (error) throw error;
  return data;
}

async function callModel<Output>(
  endpoint: AiEndpoint<unknown, Output>,
  content: UserContent,
): Promise<ModelOutcome<Output>> {
  const response = await anthropic.beta.messages.create({
    model,
    max_tokens: 8000,
    betas: ["server-side-fallback-2026-07-01"],
    fallbacks: "default",
    // Réponses courtes, attendues en quelques secondes : effort bas.
    output_config: {
      effort: "low",
      format: { type: "json_schema", schema: endpoint.outputSchema },
    },
    system: endpoint.systemPrompt,
    messages: [{ role: "user", content }],
  });

  // Refus des garde-fous du modèle (après repli éventuel) : traité comme un refus de contenu.
  if (response.stop_reason === "refusal") return { refused: true, reason: "" };
  if (response.stop_reason === "max_tokens") throw new InvalidModelOutput("truncated");

  const text = response.content.find((block) => block.type === "text");
  if (!text || text.type !== "text") throw new InvalidModelOutput("empty");
  return endpoint.interpret(text.text);
}

export function serveAiEndpoint<Req, Output>(endpoint: AiEndpoint<Req, Output>): void {
  Deno.serve(async (httpRequest) => {
    if (httpRequest.method !== "POST") return fail("invalid_request");

    const userId = await authenticatedUserId(httpRequest);
    if (!userId) return fail("unauthorized");

    let request: Req;
    let language: string;
    try {
      const body = await httpRequest.json();
      request = endpoint.parse(body);
      language = parseLanguage(body);
    } catch (error) {
      if (error instanceof InvalidRequest || error instanceof SyntaxError) {
        return fail("invalid_request");
      }
      throw error;
    }

    const { data: profile } = await admin.from("profiles")
      .select("age_confirmed_at").eq("id", userId).single();
    if (!profile?.age_confirmed_at) return fail("age_not_confirmed");

    if (endpoint.requiresPremium(request) && !(await isPremium(userId))) {
      return fail("premium_required");
    }

    const reference = crypto.randomUUID();
    const { data: spent, error: spendError } = await admin
      .rpc("spend_credits", {
        p_user: userId,
        p_cost: endpoint.cost(request),
        p_reference: reference,
      })
      .single<SpentCredits>();
    if (spendError) {
      if (spendError.message === "insufficient_credits") return fail("insufficient_credits");
      if (spendError.message === "daily_limit") return fail("daily_limit");
      if (spendError.message === "rate_limited") return fail("rate_limited");
      throw spendError;
    }

    // Un remboursement en échec est journalisé (sans contenu utilisateur) pour être rattrapé.
    const refund = async () => {
      const { error } = await admin.rpc("refund_credits", {
        p_user: userId,
        p_daily: spent.from_daily,
        p_bonus: spent.from_bonus,
        p_reference: reference,
      });
      if (error) console.error(`${endpoint.name}: refund failed`, reference, error.code);
    };

    let outcome: ModelOutcome<Output>;
    try {
      outcome = await callModel(
        endpoint as AiEndpoint<unknown, Output>,
        endpoint.userPrompt(request, language),
      );
    } catch (error) {
      await refund();
      if (error instanceof UnusableInput) return fail("unusable_input");
      // Pas de contenu utilisateur dans les journaux : seulement le type d'erreur.
      console.error(
        `${endpoint.name}: model call failed`,
        error instanceof Error ? error.name : "unknown",
      );
      return fail("ai_unavailable");
    }

    if (outcome.refused) {
      await refund();
      return json({ refused: true, reason: outcome.reason, wallet: await fetchWallet(userId) });
    }

    const { error: saveError } = await admin.from("generations").insert({
      id: reference,
      user_id: userId,
      ...endpoint.record(request, outcome.value),
    });
    if (saveError) {
      await refund();
      throw saveError;
    }

    return json({
      refused: false,
      ...endpoint.respond(reference, outcome.value),
      wallet: await fetchWallet(userId),
    });
  });
}
