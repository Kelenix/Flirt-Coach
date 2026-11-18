// Edge Function « delete-account » : supprime définitivement le compte de l'appelant
// (US-05, exigence des stores). La suppression de auth.users efface par cascade le profil,
// les crédits, les droits, l'historique et les signalements. Le client RevenueCat est aussi
// effacé si la clé secrète est configurée. L'abonnement store, lui, se résilie dans le store.
import { createClient } from "@supabase/supabase-js";

const admin = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
  { auth: { persistSession: false } },
);
const revenueCatSecret = Deno.env.get("REVENUECAT_SECRET_API_KEY") ?? "";

const reply = (status: number, body: Record<string, unknown>) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

/** Efface le client RevenueCat (RGPD). Un échec n'empêche pas la suppression du compte. */
async function deleteRevenueCatCustomer(userId: string): Promise<void> {
  if (!revenueCatSecret) return;
  try {
    const response = await fetch(
      `https://api.revenuecat.com/v1/subscribers/${encodeURIComponent(userId)}`,
      { method: "DELETE", headers: { Authorization: `Bearer ${revenueCatSecret}` } },
    );
    if (!response.ok && response.status !== 404) {
      console.error("delete-account: revenuecat", response.status);
    }
  } catch (error) {
    console.error("delete-account: revenuecat", error instanceof Error ? error.name : "unknown");
  }
}

Deno.serve(async (request) => {
  if (request.method !== "POST") return reply(405, { error: "method" });

  const token = request.headers.get("Authorization")?.replace(/^Bearer /, "");
  if (!token) return reply(401, { error: "unauthorized" });
  const { data, error } = await admin.auth.getUser(token);
  if (error) return reply(401, { error: "unauthorized" });
  const userId = data.user.id;

  await deleteRevenueCatCustomer(userId);

  const { error: deleteError } = await admin.auth.admin.deleteUser(userId);
  if (deleteError) {
    console.error("delete-account: auth", deleteError.name);
    return reply(500, { error: "delete_failed" });
  }
  return reply(200, { deleted: true });
});
