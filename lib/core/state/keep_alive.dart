import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Garde un fournisseur `autoDispose` en vie pendant [action] : son résultat peut
/// être écrit même si l'écran qui l'écoutait a disparu entre-temps (ex. le bloc
/// « Regarder une pub » se retire dès que les crédits arrivent).
Future<T> keepAliveWhile<T>(Ref ref, Future<T> Function() action) async {
  final link = ref.keepAlive();
  try {
    return await action();
  } finally {
    link.close();
  }
}

/// Action d'un contrôleur `autoDispose` (génération, achat, vidéo…).
mixin GuardedAction<T> on AutoDisposeAsyncNotifier<T> {
  /// Lance [action] : état « chargement », puis résultat ou erreur ; le contrôleur
  /// reste en vie pendant l'appel. Ignorée (renvoie `false`) si une action est déjà
  /// en cours : un double tap ne débite jamais deux fois.
  @protected
  Future<bool> runGuarded(Future<T> Function() action) async {
    if (state.isLoading) return false;
    state = AsyncLoading<T>();
    state = await keepAliveWhile(ref, () => AsyncValue.guard(action));
    return true;
  }
}
