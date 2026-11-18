// Edge Function « screenshot-reply » : 3 réponses à partir d'une capture de conversation
// (INTAKE §2.2). 2 crédits pour un utilisateur gratuit, inclus dans Premium.
// L'image n'est ni stockée ni journalisée : seules les réponses sont enregistrées (ADR-006).
import { serveAiEndpoint } from "../_shared/ai_endpoint.ts";
import { requiresPremium } from "../generate/request.ts";
import {
  parseScreenshotOutput,
  parseScreenshotRequest,
  screenshotPrompt,
  type ScreenshotRequest,
  screenshotSchema,
  systemPrompt,
} from "./screenshot.ts";

serveAiEndpoint<ScreenshotRequest, string[]>({
  name: "screenshot-reply",
  parse: parseScreenshotRequest,
  requiresPremium: (request) => requiresPremium(request.style),
  cost: () => 2,
  systemPrompt,
  userPrompt: screenshotPrompt,
  outputSchema: screenshotSchema,
  interpret: parseScreenshotOutput,
  record: (request, proposals) => ({
    kind: "screenshot",
    style: request.style,
    input_text: null,
    context_text: request.context,
    output: { proposals },
  }),
  respond: (id, proposals) => ({ id, proposals }),
});
