import { assert, assertEquals, assertThrows } from "@std/assert";

import { isUnknownUser } from "../_shared/errors.ts";
import { actionFor, baseProductId, isAuthorized, MalformedEvent } from "./revenuecat.ts";

const user = "3f6c1b7e-9a2d-4c5e-8f10-2b3c4d5e6f70";
const event = (fields: Record<string, unknown>) => ({
  api_version: "1.0",
  event: { id: "evt-1", app_user_id: user, transaction_id: "tx-1", ...fields },
});

Deno.test("pack de crédits : nombre de crédits fixé côté serveur", () => {
  assertEquals(
    actionFor(event({ type: "NON_RENEWING_PURCHASE", product_id: "flirtcoach_credits_50" })),
    { kind: "grant_credits", userId: user, amount: 50, reference: "tx-1" },
  );
});

Deno.test("abonnement : achat et renouvellement activent Premium jusqu'à l'échéance", () => {
  for (const type of ["INITIAL_PURCHASE", "RENEWAL", "UNCANCELLATION", "PRODUCT_CHANGE"]) {
    assertEquals(
      actionFor(event({
        type,
        product_id: "flirtcoach_premium_weekly:weekly-base",
        expiration_at_ms: Date.UTC(2026, 10, 25),
      })),
      {
        kind: "set_premium",
        userId: user,
        isPremium: true,
        product: "flirtcoach_premium_weekly",
        expiresAt: "2026-11-25T00:00:00.000Z",
        force: false,
      },
      type,
    );
  }
});

Deno.test("expiration : Premium retiré", () => {
  const action = actionFor(event({
    type: "EXPIRATION",
    product_id: "flirtcoach_premium_monthly",
    expiration_at_ms: Date.UTC(2026, 10, 18),
  }));
  assert(action.kind === "set_premium" && !action.isPremium && !action.force);
});

Deno.test("résiliation simple : Premium conservé jusqu'à l'échéance", () => {
  assertEquals(
    actionFor(event({
      type: "CANCELLATION",
      cancel_reason: "UNSUBSCRIBE",
      product_id: "flirtcoach_premium_annual",
    })).kind,
    "ignore",
  );
});

Deno.test("remboursement d'abonnement : Premium retiré immédiatement", () => {
  const action = actionFor(event({
    type: "CANCELLATION",
    cancel_reason: "CUSTOMER_SUPPORT",
    product_id: "flirtcoach_premium_annual",
  }));
  assert(action.kind === "set_premium" && !action.isPremium && action.force);
});

Deno.test("utilisateur retrouvé dans les alias si l'identifiant est anonyme", () => {
  const action = actionFor(event({
    type: "NON_RENEWING_PURCHASE",
    product_id: "flirtcoach_credits_20",
    app_user_id: "$RCAnonymousID:abc",
    original_app_user_id: "$RCAnonymousID:abc",
    aliases: ["$RCAnonymousID:abc", user.toUpperCase()],
  }));
  assert(action.kind === "grant_credits" && action.userId === user);
});

Deno.test("ignorés : test, utilisateur inconnu, produit inconnu, autres événements de pack", () => {
  assertEquals(actionFor(event({ type: "TEST" })).kind, "ignore");
  assertEquals(
    actionFor(event({ type: "INITIAL_PURCHASE", product_id: "x", app_user_id: "anonyme" })).kind,
    "ignore",
  );
  assertEquals(
    actionFor(event({ type: "INITIAL_PURCHASE", product_id: "autre_app" })).kind,
    "ignore",
  );
  assertEquals(
    actionFor(event({ type: "CANCELLATION", product_id: "flirtcoach_credits_100" })).kind,
    "ignore",
  );
});

Deno.test("événement mal formé : erreur", () => {
  for (const payload of [null, {}, { event: {} }, { event: "x" }]) {
    assertThrows(() => actionFor(payload), MalformedEvent);
  }
});

Deno.test("Google Play : suffixe de formule retiré", () => {
  assertEquals(
    baseProductId("flirtcoach_premium_annual:annual-promo"),
    "flirtcoach_premium_annual",
  );
  assertEquals(baseProductId("flirtcoach_credits_20"), "flirtcoach_credits_20");
});

Deno.test("secret du webhook : comparaison stricte", () => {
  assert(isAuthorized("Bearer s3cret", "s3cret"));
  assert(!isAuthorized("Bearer s3cre", "s3cret"));
  assert(!isAuthorized("s3cret", "s3cret"));
  assert(!isAuthorized(null, "s3cret"));
  assert(!isAuthorized("Bearer ", ""));
});

Deno.test("compte supprimé : reconnu pour ignorer le rappel", () => {
  assert(isUnknownUser({ code: "23503", message: "insert or update violates foreign key" }));
  assert(isUnknownUser({ code: "P0002", message: "unknown_user" }));
  assert(!isUnknownUser({ code: "P0001", message: "daily_limit" }));
  assert(!isUnknownUser({ code: "08006", message: "connection failure" }));
});

Deno.test("achat sandbox : ignoré en production, accepté en phase de test", () => {
  const sandbox = event({
    type: "NON_RENEWING_PURCHASE",
    product_id: "flirtcoach_credits_20",
    environment: "SANDBOX",
  });
  assertEquals(actionFor(sandbox), { kind: "ignore", reason: "sandbox" });
  assertEquals(actionFor(sandbox, { allowSandbox: true }).kind, "grant_credits");
  assertEquals(
    actionFor(event({
      type: "NON_RENEWING_PURCHASE",
      product_id: "flirtcoach_credits_20",
      environment: "PRODUCTION",
    })).kind,
    "grant_credits",
  );
});

Deno.test("pack remboursé : crédits repris, une seule fois par transaction", () => {
  assertEquals(
    actionFor(event({
      type: "CANCELLATION",
      cancel_reason: "CUSTOMER_SUPPORT",
      product_id: "flirtcoach_credits_50",
    })),
    { kind: "revoke_credits", userId: user, amount: 50, reference: "refund:tx-1" },
  );
  assertEquals(
    actionFor(
      event({
        type: "CANCELLATION",
        cancel_reason: "UNSUBSCRIBE",
        product_id: "flirtcoach_credits_50",
      }),
    ),
    { kind: "ignore", reason: "pack_CANCELLATION" },
  );
});
