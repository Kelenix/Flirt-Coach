/// Configuration injectée à la compilation (`--dart-define-from-file=config/<env>.json`).
abstract final class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Clés publiques du SDK RevenueCat (une par store). Vides : achats indisponibles.
  static const revenueCatAndroidKey = String.fromEnvironment(
    'REVENUECAT_ANDROID_KEY',
  );
  static const revenueCatIosKey = String.fromEnvironment('REVENUECAT_IOS_KEY');

  /// Blocs d'annonces AdMob (bannière, vidéo récompensée). Vides : pas de publicité.
  static const admobBannerAndroid = String.fromEnvironment(
    'ADMOB_BANNER_ANDROID',
  );
  static const admobRewardedAndroid = String.fromEnvironment(
    'ADMOB_REWARDED_ANDROID',
  );
  static const admobBannerIos = String.fromEnvironment('ADMOB_BANNER_IOS');
  static const admobRewardedIos = String.fromEnvironment('ADMOB_REWARDED_IOS');

  /// Éditeur de l'app (nom et adresse) cité dans les mentions légales.
  static const legalPublisher = String.fromEnvironment('LEGAL_PUBLISHER');

  /// Contact support, données personnelles et signalements. Vide : pas de lien.
  static const supportEmail = String.fromEnvironment('SUPPORT_EMAIL');

  /// `false` si l'app a été compilée sans `--dart-define-from-file` : elle ne
  /// peut alors joindre aucun serveur (voir `ConfigurationErrorApp`).
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
