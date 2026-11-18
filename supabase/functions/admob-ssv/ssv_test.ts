import { assert, assertEquals, assertThrows } from "@std/assert";

import {
  derToRaw,
  importVerifierKeys,
  InvalidCallback,
  isAllowedAdUnit,
  isSignatureValid,
  parseAdUnitList,
  parseCallback,
} from "./ssv.ts";

const user = "3f6c1b7e-9a2d-4c5e-8f10-2b3c4d5e6f70";

const toBase64 = (bytes: Uint8Array) => btoa(String.fromCharCode(...bytes));
const toBase64Url = (bytes: Uint8Array) =>
  toBase64(bytes).replaceAll("+", "-").replaceAll("/", "_").replaceAll("=", "");

/** Encode une signature brute r‖s en DER, comme le fait Google. */
function rawToDer(raw: Uint8Array): Uint8Array {
  const integer = (part: Uint8Array) => {
    let value = part;
    while (value.length > 1 && value[0] === 0) value = value.slice(1);
    if (value[0] & 0x80) value = Uint8Array.of(0, ...value);
    return Uint8Array.of(0x02, value.length, ...value);
  };
  const body = Uint8Array.of(...integer(raw.slice(0, 32)), ...integer(raw.slice(32)));
  return Uint8Array.of(0x30, body.length, ...body);
}

/** Paire de clés de test, publiée au format du fichier de clés de Google. */
async function signer(keyId: string) {
  const pair = await crypto.subtle.generateKey({ name: "ECDSA", namedCurve: "P-256" }, true, [
    "sign",
    "verify",
  ]);
  const spki = new Uint8Array(await crypto.subtle.exportKey("spki", pair.publicKey));
  const keys = await importVerifierKeys({
    keys: [{ keyId: Number(keyId), base64: toBase64(spki) }],
  });
  const sign = async (message: string) =>
    rawToDer(
      new Uint8Array(
        await crypto.subtle.sign(
          { name: "ECDSA", hash: "SHA-256" },
          pair.privateKey,
          new TextEncoder().encode(message),
        ),
      ),
    );
  return { keys, sign };
}

function callbackUrl(query: string, signature: Uint8Array, keyId: string) {
  return new URL(
    `https://example.test/functions/v1/admob-ssv?${query}&signature=${
      toBase64Url(signature)
    }&timestamp=1700000000000&transaction_id=tx-42&user_id=${user}`.replace(
      "KEY",
      keyId,
    ),
  );
}

const query =
  "ad_network=5450213213286189855&ad_unit=1234567890&custom_data=&key_id=KEY&reward_amount=2&reward_item=credits";

Deno.test("rappel signé par la bonne clé : accepté", async () => {
  const { keys, sign } = await signer("3335741209");
  const signedPart = `${query.replace("KEY", "3335741209")}`;
  const url = callbackUrl(query, await sign(signedPart), "3335741209");
  // Le message signé couvre les paramètres situés avant la signature.
  const callback = parseCallback(url);
  assertEquals(callback.message, signedPart);
  assertEquals(callback.transactionId, "tx-42");
  assertEquals(callback.userId, user);
  assert(await isSignatureValid(callback, keys));
});

Deno.test("rappel modifié, autre clé ou clé inconnue : refusé", async () => {
  const { keys, sign } = await signer("1");
  const other = await signer("1");
  const signature = await sign(query.replace("KEY", "1"));

  const tampered = parseCallback(
    callbackUrl(query.replace("reward_amount=2", "reward_amount=9"), signature, "1"),
  );
  assert(!(await isSignatureValid(tampered, keys)));

  const genuine = parseCallback(callbackUrl(query, signature, "1"));
  assert(!(await isSignatureValid(genuine, other.keys)));
  assert(!(await isSignatureValid({ ...genuine, keyId: "999" }, keys)));
});

Deno.test("rappel incomplet ou utilisateur non reconnu : rejeté", () => {
  const base = "https://example.test/fn?ad_network=1&key_id=1";
  for (
    const url of [
      `${base}`,
      `${base}&signature=AAAA&transaction_id=t`,
      `${base}&signature=AAAA&transaction_id=t&user_id=pas-un-uuid`,
      `${base}&signature=AAAA&user_id=${user}`,
    ]
  ) {
    assertThrows(() => parseCallback(new URL(url)), InvalidCallback);
  }
});

Deno.test("DER → r‖s : entiers courts complétés, zéro de signe retiré", () => {
  const raw = new Uint8Array(64);
  raw[31] = 7;
  raw.fill(0xff, 32);
  const back = derToRaw(rawToDer(raw));
  assertEquals(back, raw);
  assertThrows(() => derToRaw(Uint8Array.of(0x31, 0)), InvalidCallback);
});

Deno.test("bloc d'annonces : seuls nos blocs créditent", () => {
  const allowed = parseAdUnitList(" ca-app-pub-123/1234567890 , 9876543210 ");
  assertEquals(allowed, ["1234567890", "9876543210"]);
  assert(isAllowedAdUnit("1234567890", allowed));
  assert(!isAllowedAdUnit("5555555555", allowed));
  assert(isAllowedAdUnit("5555555555", parseAdUnitList(undefined)));
});

Deno.test("rappel sans bloc d'annonces ou key_id non numérique : refusé", () => {
  const signature = Uint8Array.of(1, 2, 3);
  assertThrows(
    () => parseCallback(callbackUrl(query.replace("ad_unit=1234567890&", ""), signature, "1")),
    InvalidCallback,
  );
  assertThrows(
    () => parseCallback(callbackUrl(query.replace("KEY", "abc"), signature, "abc")),
    InvalidCallback,
  );
});
