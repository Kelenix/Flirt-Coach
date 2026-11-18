abstract final class AppRoutes {
  static const home = '/';
  static const welcome = '/welcome';
  static const results = '/results';
  static const respect = '/respect';
  static const analysis = '/analysis';
  static const bank = '/bank';
  static const history = '/history';
  static const settings = '/settings';
  static const privacy = '/legal/privacy';
  static const terms = '/legal/terms';

  /// Pages consultables avant la confirmation d'âge (liens de l'accueil 18+).
  static const public = {privacy, terms};
  static const paywall = '/paywall';

  /// Variante J+3 du paywall, avec l'abonnement annuel mis en avant.
  static const annualOffer = '/paywall?offer=annual';
}
