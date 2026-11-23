import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/supabase_message_bank_repository.dart';
import '../domain/bank_message.dart';

/// Banque groupée par catégorie, dans la langue de l'interface (code de langue
/// en paramètre), chargée une fois par session et par langue.
final messageBankProvider =
    FutureProvider.family<Map<BankCategory, List<String>>, String>((
      ref,
      languageCode,
    ) async {
      final messages = await ref
          .watch(messageBankRepositoryProvider)
          .fetchAll(languageCode);
      return {
        for (final category in BankCategory.values)
          category: [
            for (final message in messages)
              if (message.category == category) message.body,
          ],
      };
    });
