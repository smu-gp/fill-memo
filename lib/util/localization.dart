import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sp_client/l10n/messages_all.dart';

///
/// Generate localization script
/// extract:
/// flutter packages pub run intl_translation:extract_to_arb `
/// --locale messages `
/// --output-dir=lib/l10n lib/util/localization.dart
/// generate:
/// flutter packages pub run intl_translation:generate_from_arb `
/// --output-dir=lib/l10n --no-use-deferred-loading `
/// lib/util/localization.dart lib\l10n\intl_en.arb lib\l10n\intl_ko.arb
///
class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) async {
    final String name =
        locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get appName => Intl.message(
        'sp_client',
        name: 'appName',
      );

  String get titleHistory => Intl.message(
        'History',
        name: 'titleHistory',
      );

  String get titleImageSelect => Intl.message(
        'Selected Image',
        name: 'titleImageSelect',
      );

  String get titleResult => Intl.message(
        'Result',
        name: 'titleResult',
      );

  String get actionAddImage => Intl.message(
        'Add Image',
        name: 'actionAddImage',
      );

  String get actionSort => Intl.message(
        'Sort',
        name: 'actionSort',
      );

  String get actionUndo => Intl.message(
        'Undo',
        name: 'actionUndo',
      );

  String get actionSendImage => Intl.message(
        'Send Image',
        name: 'actionSendImage',
      );

  String get imageFromGallery => Intl.message(
        'Select from gallery',
        name: 'imageFromGallery',
      );

  String get imageFromCamera => Intl.message(
        'Take from camera',
        name: 'imageFromCamera',
      );

  String get dialogSendImage => Intl.message(
        'Send image...',
        name: 'dialogSendImage',
      );

  String get dialogDeleteItem => Intl.message(
        'Are you sure to delete?',
        name: 'dialogDeleteItem',
      );

  String get orderCreatedAsc => Intl.message(
        'Created date ascending',
        name: 'orderCreatedAsc',
      );

  String get orderCreatedDes => Intl.message(
        'Created date descending',
        name: 'orderCreatedDes',
      );

  String itemDeleted(itemName) => Intl.message(
        '$itemName is deleted',
        args: [itemName],
        name: 'itemDeleted',
      );

  String get typeDate => Intl.message(
        'Date',
        name: 'typeDate',
      );

  String get typeFolder => Intl.message(
        'Folder',
        name: 'typeFolder',
      );
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ko'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
