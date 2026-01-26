import 'package:flutter/widgets.dart';
import 'package:pokedex_draftea/l10n/gen/app_localizations.dart';

export 'package:pokedex_draftea/l10n/gen/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
