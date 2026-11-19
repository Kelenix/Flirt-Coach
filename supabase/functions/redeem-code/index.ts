// Edge Function « redeem-code » : active le code d'accès Premium donné aux testeurs des
// stores (ADR-031). Le code n'est jamais stocké en clair : seule son empreinte SHA-256 est
// configurée (REVIEW_ACCESS_CODE_SHA256). Sans ce secret, aucun code n'est accepté.
import { createClient } from "@supabase/supabase-js";
import { isUnknownUser } from "../_shared/errors.ts";
import { normalizeCode, replyFor, sameHash, sha256Hex } from "./code.ts";

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false } },
);
const expectedHash = (Deno.env.get("REVIEW_ACCESS_CODE_SHA256") ?? "").trim().toLowerCase();
const maxRedemptions = Number(Deno.env.get("REVIEW_ACCESS_MAX_REDEMPTIONS") ?? "20");
const premiumDays = 30;

const reply = (status: number, body: Record<string, unknown>) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (request) => {
  if (request.method !== "POST") return reply(405, { error: "method" });

  const token = request.headers.get("Authorization")?.replace(/^Bearer /, "");
  if (!token) return reply(401, { error: "unauthorized" });
  const { data, error } = await admin.auth.getUser(token);
  if (error) return reply(401, { error: "unauthorized" });

  if (!/^[0-9a-f]{64}$/.test(expectedHash)) return reply(409, { error: "code_unavailable" });

  const body = await request.json().catch(() => null);
  const code = normalizeCode(body?.code);
  if (code === null) return reply(400, { error: "invalid_code" });

  const { data: rows, error: rpcError } = await admin.rpc("redeem_access_code", {
    p_user: data.user.id,
    p_code_hash: expectedHash,
    p_valid: sameHash(await sha256Hex(code), expectedHash),
    p_max_redemptions: maxRedemptions,
    p_days: premiumDays,
  });
  if (rpcError) {
    if (isUnknownUser(rpcError)) return reply(401, { error: "unauthorized" });
    console.error("redeem-code: rpc", rpcError.code);
    return reply(500, { error: "unexpected" });
  }

  const result = replyFor(rows?.[0]);
  return reply(result.status, result.body);
});
