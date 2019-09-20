import 'dart:async';

import 'package:fill_memo/util/i10n/messages_all.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'locale_loader_app.dart' if (dart.library.html) 'locale_loader_web.dart';

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

  String get actionSelectionAll => Intl.message(
        'Selection All',
        name: 'actionSelectionAll',
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
        'Fill Memo',
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

  String get errorEmptyCode => Intl.message(
        'Error: connection code is not empty',
        name: 'errorEmptyCode',
      );

  String get errorEmptyName => Intl.message(
        'Error: name is not empty',
        name: 'errorEmptyName',
      );

  String get folderDefault => Intl.message(
        'Default',
        name: 'folderDefault',
      );

  String get hintConnectAnotherDevice => Intl.message(
        'Connect another device by connection code',
        name: 'hintConnectAnotherDevice',
      );

  String get hintGenerateCode => Intl.message(
        'Generate code for connect another device',
        name: 'hintGenerateCode',
      );

  String get hintInputNote => Intl.message(
        'Note',
        name: 'hintInputNote',
      );

  String get hintInputTitle => Intl.message(
        'Title',
        name: 'hintInputTitle',
      );

  String get hintName => Intl.message(
        '* Setting name to display on another devices',
        name: 'hintName',
      );

  String get imageFromCamera => Intl.message(
        'Take from camera',
        name: 'imageFromCamera',
      );

  String get imageFromGallery => Intl.message(
        'Select from gallery',
        name: 'imageFromGallery',
      );

  String get labelAppInitialize => Intl.message(
        'Initialize app...',
        name: 'labelAppInitialize',
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

  String get labelDefaultMemoType => Intl.message(
        'Default memo type',
        name: 'labelDefaultMemoType',
      );

  String get labelDisconnect => Intl.message(
        'Disconnect',
        name: 'labelDisconnect',
      );

  String get labelDisconnectAnother => Intl.message(
        'Disconnect another device',
        name: 'labelDisconnectAnother',
      );

  String get labelHandWriting => Intl.message(
        'Hand writing',
        name: 'labelHandWriting',
      );

  String get labelInternalErr => Intl.message(
        'Internal server error',
        name: 'labelInternalErr',
      );

  String get labelLightTheme => Intl.message(
        'Light theme',
        name: 'labelLightTheme',
      );

  String get labelMarkdown => Intl.message(
        'Markdown',
        name: 'labelMarkdown',
      );

  String get labelName => Intl.message(
        'Name',
        name: 'labelName',
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

  String get labelRichText => Intl.message(
        'Rich text',
        name: 'labelRichText',
      );

  String get labelServiceHost => Intl.message(
        'Service host',
        name: 'labelServiceHost',
      );

  String get labelServiceUnavailable => Intl.message(
        'Service Unavailable',
        name: 'labelServiceUnavailable',
      );

  String get labelNoTitle => Intl.message(
        'No Title',
        name: 'labelNoTitle',
      );

  String get labelUnnamed => Intl.message(
        'Unnamed',
        name: 'labelUnnamed',
      );

  String get labelUpdateProfile => Intl.message(
        'Update profile',
        name: 'labelUpdateProfile',
      );

  String get labelUseFingerprint => Intl.message(
        'Use fingerprint',
        name: 'labelUseFingerprint',
      );

  String get labelVersion => Intl.message(
        'Version',
        name: 'labelVersion',
      );

  String get labelWaitConnection => Intl.message(
        'Connection...',
        name: 'labelWaitConnection',
      );

  String get labelWaitHostResponse => Intl.message(
        'Waiting host response',
        name: 'labelWaitHostResponse',
      );

  String get labelWebConnectionRequest => Intl.message(
        'Web requests connection',
        name: 'labelWebConnectionRequest',
      );

  String get labelWriteNewNoteOnStartup => Intl.message(
        'Write new note on startup',
        name: 'labelWriteNewNoteOnStartup',
      );

  String get labelNoProcessResult => Intl.message(
        'No process result',
        name: 'labelNoProcessResult',
      );

  String get labelClose => Intl.message(
        'Close',
        name: 'labelClose',
      );

  String get labelErrorOccurred => Intl.message(
        'Error occurred',
        name: 'labelErrorOccurred',
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
        'Process result',
        name: 'titleResult',
      );

  String get validationServiceHost => Intl.message(
        'Error: service host is not empty',
        name: 'validationServiceHost',
      );

  String get warnGenerateCode => Intl.message(
        'If you close the screen before connecting from another device, you will not receive a connection request.',
        name: 'warnGenerateCode',
      );

  String get labelFingerprint => Intl.message(
        'Use fingerprint to unlock',
        name: 'labelFingerprint',
      );

  String get authenticatedReason => Intl.message(
        'Please authenticate to use app',
        name: 'authenticatedReason',
      );

  String get androidFingerprintHint => Intl.message(
        'Touch sensor',
        name: 'androidFingerprintHint',
      );

  String get androidFingerprintNotRecognized => Intl.message(
        'Fingerprint not recognized. Try again.',
        name: 'androidFingerprintNotRecognized',
      );

  String get androidFingerprintSuccess => Intl.message(
        'Fingerprint recognized.',
        name: 'androidFingerprintSuccess',
      );

  String get androidCancelButton => Intl.message(
        'Cancel',
        name: 'androidCancelButton',
      );

  String get androidSignInTitle => Intl.message(
        'Fingerprint Authentication',
        name: 'androidSignInTitle',
      );

  String get androidFingerprintRequiredTitle {
    return Intl.message(
      'Fingerprint required',
      name: 'androidFingerprintRequiredTitle',
    );
  }

  String get goToSettings => Intl.message(
        'Go to settings',
        name: 'goToSettings',
      );

  String get androidGoToSettingsDescription => Intl.message(
        'Fingerprint is not set up on your device. Go to '
        '\'Settings > Security\' to add your fingerprint.',
        name: 'androidGoToSettingsDescription',
      );

  String deviceName(String displayName, String modelName) => Intl.message(
        "$displayName's $modelName",
        args: [displayName, modelName],
        name: 'deviceName',
      );

  String labelConnectionRequest(String deviceName) => Intl.message(
        '$deviceName requests connection',
        args: [deviceName],
        name: 'labelConnectionRequest',
      );

  String resultCountMessage(int resultsCount) => Intl.message(
        '$resultsCount result',
        args: [resultsCount],
        name: 'resultCountMessage',
      );

  static Future<AppLocalizations> load(Locale locale) async {
    String localeName = await initializeLocale(locale);
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
