// Edge Function « admob-ssv » : rappel serveur d'AdMob quand une vidéo récompensée a été
// vue jusqu'au bout (INTAKE §3.3). Seule voie pour gagner les 2 crédits : l'app n'en accorde
// jamais. Appelée par Google (pas de JWT) ; authenticité garantie par la signature ECDSA.
import { createClient } from "@supabase/supabase-js";

import {
  importVerifierKeys,
  InvalidCallback,
  isAllowedAdUnit,
  isSignatureValid,
  parseAdUnitList,
  parseCallback,
  verifierKeysUrl,
} from "./ssv.ts";
import { isUnknownUser } from "../_shared/errors.ts";

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false } },
);

const allowedAdUnits = parseAdUnitList(Deno.env.get("ADMOB_AD_UNIT_IDS"));

const keysTtlMs = 6 * 60 * 60 * 1000;
// Une clé inconnue force un rechargement, au plus une fois par minute (pas d'appels
// en boucle vers Google provoqués par des requêtes forgées).
const forcedRefreshMs = 60 * 1000;
let cachedKeys: { keys: Map<string, CryptoKey>; fetchedAt: number } | null = null;

/** Clés de Google en cache ; rechargées si périmées ou si la clé demandée est inconnue. */
async function verifierKeys(keyId: string): Promise<Map<string, CryptoKey>> {
  const age = cachedKeys ? Date.now() - cachedKeys.fetchedAt : Infinity;
  if (age < keysTtlMs && (cachedKeys!.keys.has(keyId) || age < forcedRefreshMs)) {
    return cachedKeys!.keys;
  }
  const response = await fetch(verifierKeysUrl);
  if (!response.ok) throw new Error(`verifier keys: HTTP ${response.status}`);
  cachedKeys = { keys: await importVerifierKeys(await response.json()), fetchedAt: Date.now() };
  return cachedKeys.keys;
}

const reply = (status: number, body: Record<string, unknown>) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (request) => {
  if (request.method !== "GET") return reply(405, { error: "method" });

  let callback;
  try {
    callback = parseCallback(new URL(request.url));
  } catch (error) {
    if (error instanceof InvalidCallback) return reply(400, { error: error.message });
    throw error;
  }

  if (!(await isSignatureValid(callback, await verifierKeys(callback.keyId)))) {
    return reply(403, { error: "bad_signature" });
  }
  if (!isAllowedAdUnit(callback.adUnit, allowedAdUnits)) {
    return reply(403, { error: "ad_unit" });
  }

  const { data: outcome, error } = await admin.rpc("claim_ad_reward", {
    p_user: callback.userId,
    p_transaction_id: callback.transactionId,
  });
  // Compte supprimé entre-temps : rien à créditer.
  if (error && isUnknownUser(error)) return reply(200, { status: "unknown_user" });
  // Autre erreur → 500 : AdMob réessaiera.
  if (error) throw error;
  // Plafond atteint ou doublon : 200 quand même, pour qu'AdMob ne réessaie pas.
  return reply(200, { status: outcome });
});
