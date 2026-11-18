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
