// Edge Function « conversation-analysis » : où en est la conversation, prochaine étape,
// rendez-vous si le contexte s'y prête (INTAKE §2.4). Réservée à Premium.
// Une capture n'est ni stockée ni journalisée : seule l'analyse est enregistrée (ADR-006).
import { serveAiEndpoint } from "../_shared/ai_endpoint.ts";
import {
  type Analysis,
  analysisPrompt,
  type AnalysisRequest,
  analysisSchema,
  parseAnalysisOutput,
  parseAnalysisRequest,
  systemPrompt,
} from "./analysis.ts";

serveAiEndpoint<AnalysisRequest, Analysis>({
  name: "conversation-analysis",
  parse: parseAnalysisRequest,
  requiresPremium: () => true,
  // Premium ne paie pas en crédits ; l'appel compte dans son plafond quotidien.
  cost: () => 1,
  systemPrompt,
  userPrompt: analysisPrompt,
  outputSchema: analysisSchema,
  interpret: parseAnalysisOutput,
  record: (request, analysis) => ({
    kind: "conversation_analysis",
    // Le style n'a pas de sens ici ; la colonne est obligatoire.
    style: "classic",
    input_text: request.input.kind === "text" ? request.input.conversation : null,
    context_text: request.context,
    output: analysis,
  }),
  respond: (id, analysis) => ({
    id,
    momentum: analysis.momentum,
    summary: analysis.summary,
    next_step: analysis.nextStep,
    suggested_message: analysis.suggestedMessage,
    date_suggestion: analysis.dateSuggestion,
  }),
});
