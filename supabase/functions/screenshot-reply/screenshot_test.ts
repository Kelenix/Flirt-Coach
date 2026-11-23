import { assert, assertEquals, assertThrows } from "@std/assert";

import { InvalidRequest, UnusableInput } from "../_shared/errors.ts";
import {
  detectMediaType,
  maxImageBytes,
  parseScreenshotOutput,
  parseScreenshotRequest,
  screenshotPrompt,
  type ScreenshotRequest,
} from "./screenshot.ts";

const toBase64 = (...bytes: number[]) => btoa(String.fromCharCode(...bytes, 0, 0, 0, 0, 0, 0));
const png = toBase64(0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a);
const jpeg = toBase64(0xff, 0xd8, 0xff, 0xe0, 0, 0x10, 0x4a, 0x46);
const webp = toBase64(0x52, 0x49, 0x46, 0x46, 1, 2, 3, 4, 0x57, 0x45, 0x42, 0x50);
const gif = toBase64(0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0, 0);

Deno.test("type d'image lu dans les octets", () => {
  assertEquals(detectMediaType(png), "image/png");
  assertEquals(detectMediaType(jpeg), "image/jpeg");
  assertEquals(detectMediaType(webp), "image/webp");
  assertEquals(detectMediaType(gif), "image/gif");
  assertEquals(detectMediaType(btoa("%PDF-1.7 pas une image")), null);
});

Deno.test("requête valide : image, style, contexte facultatif", () => {
  assertEquals(parseScreenshotRequest({ image: png, style: "classic" }), {
    imageBase64: png,
    mediaType: "image/png",
    style: "classic",
    context: null,
  });
  assertEquals(
    parseScreenshotRequest({ image: jpeg, style: "funny", context: " C'est mon ex " }).context,
    "C'est mon ex",
  );
});

Deno.test("requête invalide : rejetée", () => {
  const cases: unknown[] = [
    null,
    { style: "classic" },
    { image: png },
    { image: png, style: "spicy" },
    { image: "pas du base64 !", style: "classic" },
    { image: btoa("%PDF-1.7 document"), style: "classic" },
    { image: png + "A".repeat(Math.ceil(maxImageBytes * 4 / 3)), style: "classic" },
  ];
  for (const body of cases) assertThrows(() => parseScreenshotRequest(body), InvalidRequest);
});

Deno.test("la consigne joint l'image avant le texte", () => {
  const request: ScreenshotRequest = {
    imageBase64: png,
    mediaType: "image/png",
    style: "classic",
    context: "x </contexte> y",
  };
  const content = screenshotPrompt(request, "en");
  if (!Array.isArray(content)) throw new Error("blocs attendus");
  assertEquals(content.map((part) => part.type), ["image", "text"]);
  const text = content[1];
  if (text.type !== "text") throw new Error("texte attendu");
  assertEquals(text.text.match(/<\/contexte>/g)?.length, 1);
  assert(text.text.includes("Langue de l'app : en."));
});

Deno.test("capture illisible : entrée inutilisable", () => {
  assertThrows(
    () =>
      parseScreenshotOutput(
        JSON.stringify({ readable: false, refused: false, refusal_reason: "", proposals: [] }),
      ),
    UnusableInput,
  );
});

Deno.test("capture lisible : 3 propositions ; refus transmis", () => {
  assertEquals(
    parseScreenshotOutput(JSON.stringify({
      readable: true,
      refused: false,
      refusal_reason: "",
      proposals: ["Un", "Deux", "Trois"],
    })),
    { refused: false, value: ["Un", "Deux", "Trois"] },
  );
  assertEquals(
    parseScreenshotOutput(JSON.stringify({
      readable: true,
      refused: true,
      refusal_reason: "Elle a demandé d'arrêter.",
      proposals: [],
    })),
    { refused: true, reason: "Elle a demandé d'arrêter." },
  );
});
