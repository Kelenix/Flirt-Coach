import 'package:flirt_coach/core/errors/failure.dart';
import 'package:flirt_coach/core/supabase/edge_function.dart';
import 'package:flirt_coach/features/analysis/data/supabase_analysis_repository.dart';
import 'package:flirt_coach/features/analysis/domain/conversation_analysis.dart';
import 'package:flirt_coach/features/credits/data/supabase_wallet_repository.dart';
import 'package:flirt_coach/features/credits/domain/wallet.dart';
import 'package:flirt_coach/features/generation/data/supabase_generation_repository.dart';
import 'package:flirt_coach/features/generation/domain/generation_result.dart';
import 'package:flirt_coach/features/respect/data/supabase_respect_repository.dart';
import 'package:flirt_coach/features/respect/domain/respect_check.dart';
import 'package:flutter_test/flutter_test.dart';

/// Lecture des réponses du serveur : le chemin des crédits et des paiements.
void main() {
  const walletJson = {
    'daily_credits': 4,
    'bonus_credits': 2,
    'is_premium': false,
    'ad_rewards_left': 3,
  };

  test('portefeuille lu tel que le serveur le calcule', () {
    expect(
      walletFromJson(walletJson),
      const Wallet(
        dailyCredits: 4,
        bonusCredits: 2,
        isPremium: false,
        adRewardsLeft: 3,
      ),
    );
  });

  test('chaque code d\'erreur serveur a son message', () {
    expect(
      {
        for (final code in [
          'insufficient_credits',
          'premium_required',
          'daily_limit',
          'rate_limited',
          'ai_unavailable',
          'unusable_input',
          'inconnu',
        ])
          code: failureForFunctionError({'error': code}).runtimeType,
      },
      {
        'insufficient_credits': InsufficientCreditsFailure,
        'premium_required': PremiumRequiredFailure,
        'daily_limit': DailyLimitFailure,
        'rate_limited': RateLimitedFailure,
        'ai_unavailable': AiUnavailableFailure,
        'unusable_input': UnreadableScreenshotFailure,
        'inconnu': UnexpectedFailure,
      },
    );
    expect(failureForFunctionError('pas un objet'), isA<UnexpectedFailure>());
  });

  test('génération : propositions, ou refus motivé', () {
    final result = generationResultFromJson({
      'refused': false,
      'id': 'gen-1',
      'proposals': ['a', 42, 'b'],
      'wallet': walletJson,
    });
    expect(result, isA<GeneratedProposals>());
    expect((result as GeneratedProposals).proposals, ['a', 'b']);

    final refused = generationResultFromJson({
      'refused': true,
      'wallet': walletJson,
    });
    expect((refused as RefusedGeneration).reason, '');
  });

  test('Respect : verdict du serveur, même avec une catégorie inconnue', () {
    final check = respectCheckFromJson({
      'refused': false,
      'is_respectful': false,
      'issues': [
        {'category': 'nouvelle_categorie', 'explanation': 'x'},
      ],
      'alternative': 'Version douce',
      'wallet': walletJson,
    });
    final verdict = check as RespectVerdict;
    expect(verdict.isRespectful, isFalse);
    expect(verdict.issues, isEmpty);
    expect(verdict.alternative, 'Version douce');
  });

  test('analyse : dynamique inconnue lue comme « stagne »', () {
    final analysis = analysisFromJson({
      'refused': false,
      'momentum': 'nouvelle_valeur',
      'summary': 'S',
      'next_step': 'N',
      'suggested_message': 'M',
      'date_suggestion': null,
      'wallet': walletJson,
    });
    expect((analysis as AnalysisResult).momentum, Momentum.stalling);
    expect(analysis.dateSuggestion, isNull);
  });
}
