import 'dart:convert';

import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/features/message_bank/data/supabase_message_bank_repository.dart';
import 'package:flirt_coach/features/message_bank/domain/bank_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  // Serveur injoignable (port fermé) : simule l'absence de réseau.
  final offlineClient = SupabaseClient('http://127.0.0.1:1', 'test-key');

  test(
    'hors-ligne : la dernière copie locale de la langue est servie',
    () async {
      SharedPreferences.setMockInitialValues({
        'message_bank_cache_fr': jsonEncode([
          {'category': 'date', 'body': 'Un café ?'},
          {'category': 'inconnue', 'body': 'ignoré'},
        ]),
        'message_bank_cache_en': jsonEncode([
          {'category': 'date', 'body': 'Coffee?'},
        ]),
      });
      final repository = SupabaseMessageBankRepository(
        offlineClient,
        await SharedPreferences.getInstance(),
      );

      final messages = await repository.fetchAll('fr');

      expect(messages, hasLength(1));
      expect(messages.single.category, BankCategory.date);
      expect(messages.single.body, 'Un café ?');
    },
  );

  test('hors-ligne sans copie locale : erreur', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = SupabaseMessageBankRepository(
      offlineClient,
      await SharedPreferences.getInstance(),
    );

    expect(repository.fetchAll('fr'), throwsA(isA<Failure>()));
  });

  test('hors-ligne : jamais la copie d\'une autre langue', () async {
    SharedPreferences.setMockInitialValues({
      'message_bank_cache_fr': jsonEncode([
        {'category': 'date', 'body': 'Un café ?'},
      ]),
    });
    final repository = SupabaseMessageBankRepository(
      offlineClient,
      await SharedPreferences.getInstance(),
    );

    expect(repository.fetchAll('en'), throwsA(isA<Failure>()));
  });
}
