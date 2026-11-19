import '../../l10n/app_localizations.dart';

/// Erreur métier affichable. Les écrans ne montrent jamais une exception brute.
sealed class Failure implements Exception {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class InsufficientCreditsFailure extends Failure {
  const InsufficientCreditsFailure();
}

final class PremiumRequiredFailure extends Failure {
  const PremiumRequiredFailure();
}

final class DailyLimitFailure extends Failure {
  const DailyLimitFailure();
}

/// Trop de demandes en une minute (limite serveur).
final class RateLimitedFailure extends Failure {
  const RateLimitedFailure();
}

final class AiUnavailableFailure extends Failure {
  const AiUnavailableFailure();
}

/// La capture ne montre pas de conversation lisible ; aucun crédit débité.
final class UnreadableScreenshotFailure extends Failure {
  const UnreadableScreenshotFailure();
}

final class ImageTooLargeFailure extends Failure {
  const ImageTooLargeFailure();
}

/// Achats impossibles (store absent, produits non configurés, clé manquante).
final class PurchasesUnavailableFailure extends Failure {
  const PurchasesUnavailableFailure();
}

final class PurchaseFailedFailure extends Failure {
  const PurchaseFailedFailure();
}

/// Code d'accès Premium refusé (ADR-031).
enum AccessCodeProblem { invalid, unavailable, tooManyAttempts }

final class AccessCodeFailure extends Failure {
  const AccessCodeFailure(this.problem);

  final AccessCodeProblem problem;
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure();
}

String failureMessage(AppLocalizations l10n, Object error) => switch (error) {
  NetworkFailure() => l10n.errorNetwork,
  InsufficientCreditsFailure() => l10n.errorInsufficientCredits,
  PremiumRequiredFailure() => l10n.lockedStyle,
  DailyLimitFailure() => l10n.errorDailyLimit,
  RateLimitedFailure() => l10n.errorRateLimited,
  AiUnavailableFailure() => l10n.errorAiUnavailable,
  UnreadableScreenshotFailure() => l10n.errorUnreadableScreenshot,
  ImageTooLargeFailure() => l10n.errorImageTooLarge,
  PurchasesUnavailableFailure() => l10n.errorPurchasesUnavailable,
  PurchaseFailedFailure() => l10n.errorPurchaseFailed,
  AccessCodeFailure(:final problem) => switch (problem) {
    AccessCodeProblem.invalid => l10n.errorAccessCodeInvalid,
    AccessCodeProblem.unavailable => l10n.errorAccessCodeUnavailable,
    AccessCodeProblem.tooManyAttempts => l10n.errorAccessCodeAttempts,
  },
  _ => l10n.errorUnexpected,
};
