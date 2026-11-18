import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/config/env.dart';

/// Résultat d'une vidéo récompensée, côté téléphone. Les crédits, eux, ne viennent
/// que du serveur (rappel signé d'AdMob, Edge Function `admob-ssv`).
enum RewardedVideoResult { watched, interrupted, unavailable }

/// Publicités AdMob (INTAKE §3.3) : consentement, bannière, vidéo récompensée.
abstract interface class AdsService {
  /// Recueille le consentement (RGPD / ATT) si nécessaire et prépare le SDK.
  /// `false` : aucune publicité ne doit être demandée.
  Future<bool> prepare();

  /// Bannière discrète à placer en bas d'écran.
  Widget banner();

  /// Montre une vidéo ; [userId] est transmis à AdMob pour le rappel serveur.
  Future<RewardedVideoResult> showRewardedVideo(String userId);

  /// Le RGPD impose de pouvoir modifier son consentement : `true` si le lien
  /// « Préférences publicitaires » doit figurer dans les réglages.
  Future<bool> privacyOptionsRequired();

  /// Rouvre le formulaire de consentement publicitaire.
  Future<void> showPrivacyOptions();
}

final adsServiceProvider = Provider<AdsService>((ref) => AdMobAdsService());

/// Publicité autorisée sur cet appareil (consentement obtenu, SDK prêt).
final adsReadyProvider = FutureProvider<bool>(
  (ref) => ref.watch(adsServiceProvider).prepare(),
);

class AdMobAdsService implements AdsService {
  Future<bool>? _preparation;

  String get _bannerUnit =>
      Platform.isIOS ? Env.admobBannerIos : Env.admobBannerAndroid;

  String get _rewardedUnit =>
      Platform.isIOS ? Env.admobRewardedIos : Env.admobRewardedAndroid;

  @override
  Future<bool> prepare() => _preparation ??= _prepare();

  Future<bool> _prepare() async {
    if (_bannerUnit.isEmpty && _rewardedUnit.isEmpty) return false;
    final consentUpdated = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      consentUpdated.complete,
      // Échec réseau : on garde le consentement déjà connu.
      (error) => consentUpdated.complete(),
    );
    await consentUpdated.future;
    await ConsentForm.loadAndShowConsentFormIfRequired((error) {});
    if (!await ConsentInformation.instance.canRequestAds()) return false;
    await MobileAds.instance.initialize();
    return true;
  }

  @override
  Future<bool> privacyOptionsRequired() async {
    if (_bannerUnit.isEmpty && _rewardedUnit.isEmpty) return false;
    await prepare();
    return await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  }

  @override
  Future<void> showPrivacyOptions() =>
      ConsentForm.showPrivacyOptionsForm((error) {});

  @override
  Widget banner() => _bannerUnit.isEmpty
      ? const SizedBox.shrink()
      : _AnchoredBanner(adUnitId: _bannerUnit);

  @override
  Future<RewardedVideoResult> showRewardedVideo(String userId) async {
    if (_rewardedUnit.isEmpty || !await prepare()) {
      return RewardedVideoResult.unavailable;
    }
    final loaded = Completer<RewardedAd?>();
    await RewardedAd.load(
      adUnitId: _rewardedUnit,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: loaded.complete,
        onAdFailedToLoad: (error) => loaded.complete(null),
      ),
    );
    final ad = await loaded.future;
    if (ad == null) return RewardedVideoResult.unavailable;

    await ad.setServerSideOptions(
      ServerSideVerificationOptions(userId: userId),
    );
    var earned = false;
    final closed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        closed.complete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        closed.complete();
      },
    );
    await ad.show(onUserEarnedReward: (ad, reward) => earned = true);
    await closed.future;
    return earned
        ? RewardedVideoResult.watched
        : RewardedVideoResult.interrupted;
  }
}

/// Bannière standard 320 × 50 : discrète (INTAKE §3.3) ; ne prend de place
/// qu'une fois l'annonce chargée.
class _AnchoredBanner extends StatefulWidget {
  const _AnchoredBanner({required this.adUnitId});

  final String adUnitId;

  @override
  State<_AnchoredBanner> createState() => _AnchoredBannerState();
}

class _AnchoredBannerState extends State<_AnchoredBanner> {
  late final BannerAd _ad = BannerAd(
    adUnitId: widget.adUnitId,
    size: AdSize.banner,
    request: const AdRequest(),
    listener: BannerAdListener(
      onAdLoaded: (ad) {
        if (mounted) setState(() => _isLoaded = true);
      },
      onAdFailedToLoad: (ad, error) => ad.dispose(),
    ),
  )..load();
  bool _isLoaded = false;

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox.shrink();
    return SizedBox(
      width: _ad.size.width.toDouble(),
      height: _ad.size.height.toDouble(),
      child: AdWidget(ad: _ad),
    );
  }
}
