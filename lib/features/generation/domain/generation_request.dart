import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'message_style.dart';
import 'situation.dart';

part 'generation_request.freezed.dart';

@freezed
abstract class GenerationRequest with _$GenerationRequest {
  const factory GenerationRequest({
    required Situation situation,
    required MessageStyle style,

    /// Message reçu ; utilisé seulement si la situation l'exige.
    String? message,

    /// Précisions facultatives de l'utilisateur sur la situation.
    String? context,

    /// Capture de la conversation, à la place du message reçu (INTAKE §2.2).
    Uint8List? screenshot,
  }) = _GenerationRequest;

  const GenerationRequest._();

  /// Coût pour un utilisateur gratuit : la lecture d'une capture coûte 2 crédits.
  int get cost => screenshot == null ? 1 : 2;
}
