import 'generation_request.dart';
import 'generation_result.dart';

/// Génération de messages. Les erreurs sont des `Failure`.
abstract interface class GenerationRepository {
  /// 3 propositions pour la situation demandée (1 crédit).
  Future<GenerationResult> generate(GenerationRequest request);
}
