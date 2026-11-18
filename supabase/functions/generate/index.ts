// Edge Function « generate » : 3 messages pour l'une des 7 situations (INTAKE §2.1, §4).
import { serveAiEndpoint } from "../_shared/ai_endpoint.ts";
import { outputSchema, parseModelOutput, systemPrompt, userPrompt } from "./prompt.ts";
import { type GenerationRequest, parseRequest, requiresPremium } from "./request.ts";

serveAiEndpoint<GenerationRequest, string[]>({
  name: "generate",
  parse: parseRequest,
  requiresPremium: (request) => requiresPremium(request.style),
  cost: () => 1,
  systemPrompt,
  userPrompt,
  outputSchema,
  interpret: parseModelOutput,
  record: (request, proposals) => ({
    kind: request.situation,
    style: request.style,
    input_text: request.message,
    context_text: request.context,
    output: { proposals },
  }),
  respond: (id, proposals) => ({ id, proposals }),
});
