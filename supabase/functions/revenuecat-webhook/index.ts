// Edge Function « revenuecat-webhook » : seule source des droits Premium et des crédits
// achetés (ADR-004). Appelée par RevenueCat, pas par l'app : pas de jeton utilisateur, mais
// un secret partagé dans l'en-tête Authorization. Idempotente : RevenueCat peut rejouer.
import { createClient } from "@supabase/supabase-js";

import { isUnknownUser } from "../_shared/errors.ts";
import { actionFor, isAuthorized, MalformedEvent } from "./revenuecat.ts";

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false } },
);
const secret = Deno.env.get("REVENUECAT_WEBHOOK_SECRET") ?? "";
// Achats sandbox acceptés seulement pendant la phase de test (à retirer avant publication).
const allowSandbox = Deno.env.get("REVENUECAT_ALLOW_SANDBOX") === "true";

const reply = (status: number, body: Record<string, unknown>) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (request) => {
  if (request.method !== "POST") return reply(405, { error: "method" });
  if (!isAuthorized(request.headers.get("Authorization"), secret)) {
    return reply(401, { error: "unauthorized" });
  }

  let action;
  try {
    action = actionFor(await request.json(), { allowSandbox });
  } catch (error) {
    if (error instanceof MalformedEvent || error instanceof SyntaxError) {
      return reply(400, { error: "malformed_event" });
    }
    throw error;
  }

  switch (action.kind) {
    case "ignore":
      return reply(200, { status: "ignored", reason: action.reason });
    case "grant_credits": {
      const { data, error } = await admin.rpc("grant_credits", {
        p_user: action.userId,
        p_amount: action.amount,
        p_kind: "purchase",
        p_reference: action.reference,
      });
      if (error && isUnknownUser(error)) return reply(200, { status: "unknown_user" });
      // Autre erreur → 500 : RevenueCat renverra l'événement plus tard.
      if (error) throw error;
      return reply(200, { status: data ? "credited" : "duplicate" });
    }
    case "revoke_credits": {
      const { data, error } = await admin.rpc("revoke_credits", {
        p_user: action.userId,
        p_amount: action.amount,
        p_reference: action.reference,
      });
      if (error && isUnknownUser(error)) return reply(200, { status: "unknown_user" });
      if (error) throw error;
      return reply(200, { status: "revoked", amount: data });
    }
    case "set_premium": {
      const { error } = await admin.rpc("set_premium", {
        p_user: action.userId,
        p_is_premium: action.isPremium,
        p_product: action.product,
        p_expires_at: action.expiresAt,
        p_force: action.force,
      });
      if (error && isUnknownUser(error)) return reply(200, { status: "unknown_user" });
      if (error) throw error;
      return reply(200, { status: action.isPremium ? "premium_on" : "premium_off" });
    }
    case "transfer_premium": {
      const { data, error } = await admin.rpc("transfer_premium", {
        p_from: action.from,
        p_to: action.to,
      });
      if (error && isUnknownUser(error)) return reply(200, { status: "unknown_user" });
      if (error) throw error;
      return reply(200, { status: data ? "premium_transferred" : "nothing_to_transfer" });
    }
  }
});
