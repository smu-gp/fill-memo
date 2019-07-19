import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sp_client/util/i10n/messages_all.dart';

class AppLocalizations {
  String get actionAccept => Intl.message(
        'Accept',
        name: 'actionAccept',
      );

  String get actionAdd => Intl.message(
        'Add',
        name: 'actionAdd',
      );

  String get actionAddFolder => Intl.message(
        'Add folder',
        name: 'actionAddFolder',
      );

  String get actionAddMemo => Intl.message(
        'Add memo',
        name: 'actionAddMemo',
      );

  String get actionAddTextFromImage => Intl.message(
        'Add text from image',
        name: 'actionAddTextFromImage',
      );

  String get actionConnect => Intl.message(
        'Connect',
        name: 'actionConnect',
      );

  String get actionConnection => Intl.message(
        'Connection',
        name: 'actionConnection',
      );

  String get actionCreateNewFolder => Intl.message(
        'Create new folder',
        name: 'actionCreateNewFolder',
      );

  String get actionDarkMode => Intl.message(
        'Dark mode',
        name: 'actionDarkMode',
      );

  String get actionDate => Intl.message(
        'Date',
        name: 'actionDate',
      );

  String get actionDelete => Intl.message(
        'Delete',
        name: 'actionDelete',
      );

  String get actionEdit => Intl.message(
        'Edit',
        name: 'actionEdit',
      );

  String get actionFolder => Intl.message(
        'Folder',
        name: 'actionFolder',
      );

  String get actionManageFolder => Intl.message(
        'Manage folder',
        name: 'actionManageFolder',
      );

  String get actionMoveFolder => Intl.message(
        'Move another folder',
        name: 'actionMoveFolder',
      );

  String get actionNotes => Intl.message(
        'Notes',
        name: 'actionNotes',
      );

  String get actionReject => Intl.message(
        'Reject',
        name: 'actionReject',
      );

  String get actionRemoveFolder => Intl.message(
        'Remove folder',
        name: 'actionRemoveFolder',
      );

  String get actionRename => Intl.message(
        'Rename',
        name: 'actionRename',
      );

  String get actionRenameFolder => Intl.message(
        'Rename folder',
        name: 'actionRenameFolder',
      );

  String get actionRetry => Intl.message(
        'Retry',
        name: 'actionRetry',
      );

  String get actionSecretFolder => Intl.message(
        'Secret folder',
        name: 'actionSecretFolder',
      );

  String get actionSendImage => Intl.message(
        'Send image',
        name: 'actionSendImage',
      );

  String get actionSettings => Intl.message(
        'Settings',
        name: 'actionSettings',
      );

  String get actionSort => Intl.message(
        'Sort',
        name: 'actionSort',
      );

  String get appName => Intl.message(
        'sp_client',
        name: 'appName',
      );

  String get dialogConnectionWithDevice => Intl.message(
        'Connection with device?',
        name: 'dialogConnectionWithDevice',
      );

  String get dialogDeleteFolder => Intl.message(
        'All the notes in the folder are moved to the default folder. Delete folder?',
        name: 'dialogDeleteFolder',
      );

  String get dialogDeleteItem => Intl.message(
        'Are you sure to delete?',
        name: 'dialogDeleteItem',
      );

  String get dialogFolderSelect => Intl.message(
        'Folder Select',
        name: 'dialogFolderSelect',
      );

  String get dialogSendImage => Intl.message(
        'Send image...',
        name: 'dialogSendImage',
      );

  String get errorEmptyName => Intl.message(
        'Error: name is not empty',
        name: 'errorEmptyName',
      );

  String get folderDefault => Intl.message(
        'Default',
        name: 'folderDefault',
      );

  String get hintInputNote => Intl.message(
        'Note',
        name: 'hintInputNote',
      );

  String get hintInputTitle => Intl.message(
        'Title',
        name: 'hintInputTitle',
      );

  String get imageFromCamera => Intl.message(
        'Take from camera',
        name: 'imageFromCamera',
      );

  String get imageFromGallery => Intl.message(
        'Select from gallery',
        name: 'imageFromGallery',
      );

  String get labelAuthFailed => Intl.message(
        'Auth failed',
        name: 'labelAuthFailed',
      );

  String get labelChangePinCode => Intl.message(
        'Change pin code',
        name: 'labelChangePinCode',
      );

  String get labelConnectFailed => Intl.message(
        'Connect failed',
        name: 'labelConnectFailed',
      );

  String get labelConnectionCode => Intl.message(
        'Connection code',
        name: 'labelConnectionCode',
      );

  String get labelConnectSuccess => Intl.message(
        'Connect success',
        name: 'labelConnectSuccess',
      );

  String get labelInternalErr => Intl.message(
        'Internal server error',
        name: 'labelInternalErr',
      );

  String get labelLightTheme => Intl.message(
        'Light theme',
        name: 'labelLightTheme',
      );

  String get labelNoHostWaited => Intl.message(
        'No host waited',
        name: 'labelNoHostWaited',
      );

  String get labelNone => Intl.message(
        'None',
        name: 'labelNone',
      );

  String get labelQuickFolderClassification => Intl.message(
        'Quick folder classification',
        name: 'labelQuickFolderClassification',
      );

  String get labelRejectHost => Intl.message(
        'Reject by host',
        name: 'labelRejectHost',
      );

  String get labelResponseTimeout => Intl.message(
        'Host Response timeout',
        name: 'labelResponseTimeout',
      );

  String get labelServiceHost => Intl.message(
        'Service host',
        name: 'labelServiceHost',
      );

  String get labelUseFingerprint => Intl.message(
        'Use fingerprint',
        name: 'labelUseFingerprint',
      );

  String get labelVersion => Intl.message(
        'Version',
        name: 'labelVersion',
      );

  String get labelWaitHostResponse => Intl.message(
        'Waiting host response',
        name: 'labelWaitHostResponse',
      );

  String get labelWriteNewNoteOnStartup => Intl.message(
        'Write new note on startup',
        name: 'labelWriteNewNoteOnStartup',
      );

  String get memoEmpty => Intl.message(
        'Empty memo',
        name: 'memoEmpty',
      );

  String get memoError => Intl.message(
        'Error occurred',
        name: 'memoError',
      );

  String get orderByCreated => Intl.message(
        'Created date',
        name: 'orderByCreated',
      );

  String get orderByUpdated => Intl.message(
        'Updated date',
        name: 'orderByUpdated',
      );

  String get orderCreatedAsc => Intl.message(
        'Created date ascending',
        name: 'orderCreatedAsc',
      );

  String get orderCreatedDes => Intl.message(
        'Created date descending',
        name: 'orderCreatedDes',
      );

  String get orderType => Intl.message(
        'Order type',
        name: 'orderType',
      );

  String get orderTypeAsc => Intl.message(
        'Ascending',
        name: 'orderTypeAsc',
      );

  String get orderTypeDes => Intl.message(
        'Descending',
        name: 'orderTypeDes',
      );

  String get subtitleDebug => Intl.message(
        'Debug',
        name: 'subtitleDebug',
      );

  String get subtitleInfo => Intl.message(
        'Info',
        name: 'subtitleInfo',
      );

  /// SettingsScreen Strings
  String get subtitleNote => Intl.message(
        'Note',
        name: 'subtitleNote',
      );

  String get subtitleQuickFolderClassification => Intl.message(
        'Folder classification on write new note title',
        name: 'subtitleQuickFolderClassification',
      );

  String get subtitleSecurity => Intl.message(
        'Security',
        name: 'subtitleSecurity',
      );

  String get titleAddImage => Intl.message(
        'Select image area to send',
        name: 'titleAddImage',
      );

  String get titleGuestConnection => Intl.message(
        'Connect another device',
        name: 'titleGuestConnection',
      );

  String get titleHistory => Intl.message(
        'History',
        name: 'titleHistory',
      );

  String get titleHostConnection => Intl.message(
        'Get connection code',
        name: 'titleHostConnection',
      );

  String get titleResult => Intl.message(
        'Result',
        name: 'titleResult',
      );

  String get validationServiceHost => Intl.message(
        'Error: service host is not empty',
        name: 'validationServiceHost',
      );

  String resultCountMessage(int resultsCount) => Intl.message(
        '$resultsCount result',
        args: [resultsCount],
        name: 'resultCountMessage',
      );

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
