// Edge Function « respect-check » : vérifie un message avant envoi (INTAKE §2.6).
// 1 crédit pour un utilisateur gratuit, inclus dans Premium.
import { serveAiEndpoint } from "../_shared/ai_endpoint.ts";
import {
  parseRespectOutput,
  parseRespectRequest,
  respectPrompt,
  type RespectRequest,
  respectSchema,
  type RespectVerdict,
  systemPrompt,
} from "./respect.ts";

serveAiEndpoint<RespectRequest, RespectVerdict>({
  name: "respect-check",
  parse: parseRespectRequest,
  requiresPremium: () => false,
  cost: () => 1,
  systemPrompt,
  userPrompt: respectPrompt,
  outputSchema: respectSchema,
  interpret: parseRespectOutput,
  record: (request, verdict) => ({
    kind: "respect_check",
    // Le style n'a pas de sens ici ; la colonne est obligatoire.
    style: "classic",
    input_text: request.message,
    context_text: request.context,
    output: verdict,
  }),
  respond: (id, verdict) => ({
    id,
    is_respectful: verdict.isRespectful,
    issues: verdict.issues,
    alternative: verdict.alternative,
  }),
});
