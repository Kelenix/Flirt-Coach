import '../../../l10n/app_localizations.dart';
import '../domain/message_style.dart';
import '../domain/situation.dart';

extension MessageStyleLabel on MessageStyle {
  String label(AppLocalizations l10n) => switch (this) {
    MessageStyle.classic => l10n.styleClassic,
    MessageStyle.funny => l10n.styleFunny,
    MessageStyle.romantic => l10n.styleRomantic,
    MessageStyle.mysterious => l10n.styleMysterious,
    MessageStyle.direct => l10n.styleDirect,
    MessageStyle.elegant => l10n.styleElegant,
    MessageStyle.playfulBold => l10n.stylePlayfulBold,
  };
}

extension SituationLabels on Situation {
  String label(AppLocalizations l10n) => switch (this) {
    Situation.reply => l10n.situationReply,
    Situation.opener => l10n.situationOpener,
    Situation.flirt => l10n.situationFlirt,
    Situation.followUp => l10n.situationFollowUp,
    Situation.preDate => l10n.situationPreDate,
    Situation.apology => l10n.situationApology,
    Situation.softBreakup => l10n.situationSoftBreakup,
  };

  String contextHint(AppLocalizations l10n) => switch (this) {
    Situation.reply => l10n.contextHintReply,
    Situation.opener => l10n.contextHintOpener,
    Situation.flirt => l10n.contextHintFlirt,
    Situation.followUp => l10n.contextHintFollowUp,
    Situation.preDate => l10n.contextHintPreDate,
    Situation.apology => l10n.contextHintApology,
    Situation.softBreakup => l10n.contextHintSoftBreakup,
  };
}
