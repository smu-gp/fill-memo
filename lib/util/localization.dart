import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sp_client/util/i10n/messages_all.dart';

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

  String get titleAddImage => Intl.message(
        'Select image area to send',
        name: 'titleAddImage',
      );

  String get titleResult => Intl.message(
        'Result',
        name: 'titleResult',
      );

  String get actionAdd => Intl.message(
        'Add',
        name: 'actionAdd',
      );

  String get actionAddImage => Intl.message(
        'Add image',
        name: 'actionAddImage',
      );

  String get actionAddFolder => Intl.message(
        'Add folder',
        name: 'actionAddFolder',
      );

  String get actionSort => Intl.message(
        'Sort',
        name: 'actionSort',
      );

  String get actionEdit => Intl.message(
        'Edit',
        name: 'actionEdit',
      );

  String get actionDelete => Intl.message(
        'Delete',
        name: 'actionDelete',
      );

  String get actionMoveFolder => Intl.message(
        'Move another folder',
        name: 'actionMoveFolder',
      );

  String get actionSendImage => Intl.message(
        'Send image',
        name: 'actionSendImage',
      );

  String get actionSettings => Intl.message(
        'Settings',
        name: 'actionSettings',
      );

  String get actionRename => Intl.message(
        'Rename',
        name: 'actionRename',
      );

  String get actionRenameFolder => Intl.message(
        'Rename folder',
        name: 'actionRenameFolder',
      );

  String get actionRemoveFolder => Intl.message(
        'Remove folder',
        name: 'actionRemoveFolder',
      );

  String get imageFromGallery => Intl.message(
        'Select from gallery',
        name: 'imageFromGallery',
      );

  String get imageFromCamera => Intl.message(
        'Take from camera',
        name: 'imageFromCamera',
      );

  String get dialogFolderSelect => Intl.message(
        'Folder Select',
        name: 'dialogFolderSelect',
      );

  String get dialogSendImage => Intl.message(
        'Send image...',
        name: 'dialogSendImage',
      );

  String get dialogDeleteItem => Intl.message(
        'Are you sure to delete?',
        name: 'dialogDeleteItem',
      );

  String get dialogDeleteFolder => Intl.message(
        'All the histories in the folder are moved to the default folder. Delete folder?',
        name: 'dialogDeleteFolder',
      );

  String get orderCreatedAsc => Intl.message(
        'Created date ascending',
        name: 'orderCreatedAsc',
      );

  String get orderCreatedDes => Intl.message(
        'Created date descending',
        name: 'orderCreatedDes',
      );

  String get folderDefault => Intl.message(
        'Default',
        name: 'folderDefault',
      );

  String get historyEmpty => Intl.message(
        'Empty history',
        name: 'historyEmpty',
      );

  String resultCountMessage(int resultsCount) => Intl.message(
        '$resultsCount result',
        args: [resultsCount],
        name: 'resultCountMessage',
      );

  String get errorEmptyName => Intl.message(
        'Error: name is not empty',
        name: 'errorEmptyName',
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
