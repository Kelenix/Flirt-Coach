import 'package:flirt_coach/features/history/data/supabase_history_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<String, dynamic> row(String kind, Map<String, dynamic> output) => {
    'id': 'id-1',
    'kind': kind,
    'input_text': kind == 'screenshot' ? null : 'Salut',
    'output': output,
    'created_at': '2026-11-18T10:00:00.123456+00:00',
  };

  test('génération et capture : les 3 propositions', () {
    for (final kind in ['reply', 'opener', 'screenshot']) {
      final entry = entryFromRow(
        row(kind, {
          'proposals': ['a', 'b', 'c'],
        }),
      );
      expect(entry.results, ['a', 'b', 'c']);
    }
    expect(entryFromRow(row('screenshot', {'proposals': []})).input, isNull);
  });

  test('Mode Respect : l\'alternative, rien si le message était correct', () {
    expect(
      entryFromRow(
        row('respect_check', {
          'isRespectful': false,
          'issues': [],
          'alternative': 'Version douce',
        }),
      ).results,
      ['Version douce'],
    );
    expect(
      entryFromRow(
        row('respect_check', {
          'isRespectful': true,
          'issues': [],
          'alternative': null,
        }),
      ).results,
      isEmpty,
    );
  });

  test('analyse : message conseillé, puis rendez-vous s\'il existe', () {
    expect(
      entryFromRow(
        row('conversation_analysis', {
          'momentum': 'progressing',
          'suggestedMessage': 'On se voit ?',
          'dateSuggestion': 'Un café samedi ?',
        }),
      ).results,
      ['On se voit ?', 'Un café samedi ?'],
    );
    expect(
      entryFromRow(
        row('conversation_analysis', {
          'momentum': 'declining',
          'suggestedMessage': 'Bonne semaine !',
          'dateSuggestion': null,
        }),
      ).results,
      ['Bonne semaine !'],
    );
  });

  test('date convertie en heure locale', () {
    final entry = entryFromRow(row('reply', {'proposals': []}));
    expect(entry.createdAt.isUtc, isFalse);
    expect(
      entry.createdAt.toUtc(),
      DateTime.utc(2026, 11, 18, 10, 0, 0, 123, 456),
    );
  });
}
