import { assertEquals } from "@std/assert";
import { normalizeCode, replyFor, sameHash, sha256Hex } from "./code.ts";

Deno.test("normalizeCode : ignore espaces, tirets et casse", () => {
  assertEquals(normalizeCode(" k7qm-4rtx 9pzd-w2hf "), "K7QM4RTX9PZDW2HF");
});

Deno.test("normalizeCode : refuse un format inattendu", () => {
  assertEquals(normalizeCode(undefined), null);
  assertEquals(normalizeCode(1234), null);
  assertEquals(normalizeCode("ABC"), null);
  assertEquals(normalizeCode("CODE_AVEC_SOULIGNÉ"), null);
  assertEquals(normalizeCode("A".repeat(65)), null);
});

Deno.test("sha256Hex : empreinte hexadécimale connue", async () => {
  assertEquals(
    await sha256Hex("abc"),
    "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
  );
});

Deno.test("sameHash : égalité stricte", () => {
  assertEquals(sameHash("ab12", "ab12"), true);
  assertEquals(sameHash("ab12", "ab13"), false);
  assertEquals(sameHash("ab12", "ab1"), false);
});

Deno.test("replyFor : chaque résultat a sa réponse", () => {
  assertEquals(replyFor({ status: "granted", expires_at: "2026-12-19T10:00:00Z" }), {
    status: 200,
    body: { granted: true, expires_at: "2026-12-19T10:00:00Z" },
  });
  assertEquals(replyFor({ status: "invalid", expires_at: null }).body, { error: "invalid_code" });
  assertEquals(replyFor({ status: "unavailable", expires_at: null }).status, 409);
  assertEquals(replyFor({ status: "rate_limited", expires_at: null }), {
    status: 429,
    body: { error: "too_many_attempts" },
  });
  assertEquals(replyFor(undefined).status, 500);
});
