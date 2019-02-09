import 'dart:async';
import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppLocalizations {
  static Map<dynamic, dynamic> _localizedValues;

  const AppLocalizations();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  Future<AppLocalizations> load(Locale locale) async {
    var resource = await rootBundle
        .loadString('assets/locale/l10n_${locale.languageCode}.json');
    _localizedValues = json.decode(resource);
    return this;
  }

  String get(String key) {
    return _localizedValues[key];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations().load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
