import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/supabase_message_bank_repository.dart';
import '../domain/bank_message.dart';

/// Banque groupée par catégorie, chargée une fois par session.
final messageBankProvider = FutureProvider<Map<BankCategory, List<String>>>((
  ref,
) async {
  final messages = await ref.watch(messageBankRepositoryProvider).fetchAll();
  return {
    for (final category in BankCategory.values)
      category: [
        for (final message in messages)
          if (message.category == category) message.body,
      ],
  };
});
