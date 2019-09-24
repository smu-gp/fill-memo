// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(displayName, modelName) => "${displayName}\'s ${modelName}";

  static m1(deviceName) => "${deviceName} requests connection";

  static m2(resultsCount) => "${resultsCount} result";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "actionAccept" : MessageLookupByLibrary.simpleMessage("Accept"),
    "actionAdd" : MessageLookupByLibrary.simpleMessage("Add"),
    "actionAddFolder" : MessageLookupByLibrary.simpleMessage("Add folder"),
    "actionAddMemo" : MessageLookupByLibrary.simpleMessage("Add memo"),
    "actionAddTextFromImage" : MessageLookupByLibrary.simpleMessage("Add text from image"),
    "actionConnect" : MessageLookupByLibrary.simpleMessage("Connect"),
    "actionConnection" : MessageLookupByLibrary.simpleMessage("Connection"),
    "actionCreateNewFolder" : MessageLookupByLibrary.simpleMessage("Create new folder"),
    "actionDarkMode" : MessageLookupByLibrary.simpleMessage("Dark mode"),
    "actionDate" : MessageLookupByLibrary.simpleMessage("Date"),
    "actionDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "actionEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "actionFolder" : MessageLookupByLibrary.simpleMessage("Folder"),
    "actionManageFolder" : MessageLookupByLibrary.simpleMessage("Manage folder"),
    "actionMoveFolder" : MessageLookupByLibrary.simpleMessage("Move another folder"),
    "actionNotes" : MessageLookupByLibrary.simpleMessage("Notes"),
    "actionReject" : MessageLookupByLibrary.simpleMessage("Reject"),
    "actionRemoveFolder" : MessageLookupByLibrary.simpleMessage("Remove folder"),
    "actionRename" : MessageLookupByLibrary.simpleMessage("Rename"),
    "actionRenameFolder" : MessageLookupByLibrary.simpleMessage("Rename folder"),
    "actionRetry" : MessageLookupByLibrary.simpleMessage("Retry"),
    "actionSecretFolder" : MessageLookupByLibrary.simpleMessage("Secret folder"),
    "actionSelectionAll" : MessageLookupByLibrary.simpleMessage("Selection All"),
    "actionSendImage" : MessageLookupByLibrary.simpleMessage("Send image"),
    "actionSettings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "actionSort" : MessageLookupByLibrary.simpleMessage("Sort"),
    "androidCancelButton" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "androidFingerprintHint" : MessageLookupByLibrary.simpleMessage("Touch sensor"),
    "androidFingerprintNotRecognized" : MessageLookupByLibrary.simpleMessage("Fingerprint not recognized. Try again."),
    "androidFingerprintRequiredTitle" : MessageLookupByLibrary.simpleMessage("Fingerprint required"),
    "androidFingerprintSuccess" : MessageLookupByLibrary.simpleMessage("Fingerprint recognized."),
    "androidGoToSettingsDescription" : MessageLookupByLibrary.simpleMessage("Fingerprint is not set up on your device. Go to \'Settings > Security\' to add your fingerprint."),
    "androidSignInTitle" : MessageLookupByLibrary.simpleMessage("Fingerprint Authentication"),
    "appName" : MessageLookupByLibrary.simpleMessage("Fill Memo"),
    "authenticatedReason" : MessageLookupByLibrary.simpleMessage("Please authenticate to use app"),
    "connectionCodeHelp" : MessageLookupByLibrary.simpleMessage("Connection code?"),
    "connectionCodeNavigate" : MessageLookupByLibrary.simpleMessage("Connection > Generate connection code"),
    "connectionCodePrefix" : MessageLookupByLibrary.simpleMessage("Connection code required to connect the device Fill memo application installed. can be found "),
    "connectionCodeSuffix" : MessageLookupByLibrary.simpleMessage(" in the application."),
    "deviceName" : m0,
    "dialogConnectionWithDevice" : MessageLookupByLibrary.simpleMessage("Connection with device?"),
    "dialogDeleteFolder" : MessageLookupByLibrary.simpleMessage("All the notes in the folder are moved to the default folder. Delete folder?"),
    "dialogDeleteItem" : MessageLookupByLibrary.simpleMessage("Are you sure to delete?"),
    "dialogFolderSelect" : MessageLookupByLibrary.simpleMessage("Folder Select"),
    "dialogSendImage" : MessageLookupByLibrary.simpleMessage("Send image..."),
    "errorEmptyCode" : MessageLookupByLibrary.simpleMessage("Error: connection code is not empty"),
    "errorEmptyName" : MessageLookupByLibrary.simpleMessage("Error: name is not empty"),
    "folderDefault" : MessageLookupByLibrary.simpleMessage("Default"),
    "goToSettings" : MessageLookupByLibrary.simpleMessage("Go to settings"),
    "hintConnectAnotherDevice" : MessageLookupByLibrary.simpleMessage("Connect another device by connection code"),
    "hintGenerateCode" : MessageLookupByLibrary.simpleMessage("Generate code for connect another device"),
    "hintInputNote" : MessageLookupByLibrary.simpleMessage("Note"),
    "hintInputTitle" : MessageLookupByLibrary.simpleMessage("Title"),
    "hintName" : MessageLookupByLibrary.simpleMessage("* Setting name to display on another devices"),
    "imageFromCamera" : MessageLookupByLibrary.simpleMessage("Take from camera"),
    "imageFromGallery" : MessageLookupByLibrary.simpleMessage("Select from gallery"),
    "labelAppInitialize" : MessageLookupByLibrary.simpleMessage("Initialize app..."),
    "labelAppendTypeNewLine" : MessageLookupByLibrary.simpleMessage("New line"),
    "labelAppendTypeNone" : MessageLookupByLibrary.simpleMessage("None"),
    "labelAppendTypeSpace" : MessageLookupByLibrary.simpleMessage("Space"),
    "labelAuthFailed" : MessageLookupByLibrary.simpleMessage("Auth failed"),
    "labelChangePinCode" : MessageLookupByLibrary.simpleMessage("Change pin code"),
    "labelClose" : MessageLookupByLibrary.simpleMessage("Close"),
    "labelConnectFailed" : MessageLookupByLibrary.simpleMessage("Connect failed"),
    "labelConnectSuccess" : MessageLookupByLibrary.simpleMessage("Connect success"),
    "labelConnectionCode" : MessageLookupByLibrary.simpleMessage("Connection code"),
    "labelConnectionRequest" : m1,
    "labelDefaultMemoType" : MessageLookupByLibrary.simpleMessage("Default memo type"),
    "labelDeviceConnect" : MessageLookupByLibrary.simpleMessage("Device connect"),
    "labelDisconnect" : MessageLookupByLibrary.simpleMessage("Disconnect"),
    "labelDisconnectAnother" : MessageLookupByLibrary.simpleMessage("Disconnect another device"),
    "labelErrorOccurred" : MessageLookupByLibrary.simpleMessage("Error occurred"),
    "labelFingerprint" : MessageLookupByLibrary.simpleMessage("Use fingerprint to unlock"),
    "labelHandWriting" : MessageLookupByLibrary.simpleMessage("Hand writing"),
    "labelInternalErr" : MessageLookupByLibrary.simpleMessage("Internal server error"),
    "labelLightTheme" : MessageLookupByLibrary.simpleMessage("Light theme"),
    "labelMarkdown" : MessageLookupByLibrary.simpleMessage("Markdown"),
    "labelName" : MessageLookupByLibrary.simpleMessage("Name"),
    "labelNoHostWaited" : MessageLookupByLibrary.simpleMessage("No host waited"),
    "labelNoProcessResult" : MessageLookupByLibrary.simpleMessage("No process result"),
    "labelNoTitle" : MessageLookupByLibrary.simpleMessage("No Title"),
    "labelNone" : MessageLookupByLibrary.simpleMessage("None"),
    "labelQuickFolderClassification" : MessageLookupByLibrary.simpleMessage("Quick folder classification"),
    "labelQuickMemoWriting" : MessageLookupByLibrary.simpleMessage("Quick memo writing"),
    "labelRejectHost" : MessageLookupByLibrary.simpleMessage("Reject by host"),
    "labelResponseTimeout" : MessageLookupByLibrary.simpleMessage("Host Response timeout"),
    "labelResultAppendType" : MessageLookupByLibrary.simpleMessage("Result append type"),
    "labelRichText" : MessageLookupByLibrary.simpleMessage("Rich text"),
    "labelServiceHost" : MessageLookupByLibrary.simpleMessage("Service host"),
    "labelServiceUnavailable" : MessageLookupByLibrary.simpleMessage("Service Unavailable"),
    "labelUnnamed" : MessageLookupByLibrary.simpleMessage("Unnamed"),
    "labelUpdateProfile" : MessageLookupByLibrary.simpleMessage("Update profile"),
    "labelUseFingerprint" : MessageLookupByLibrary.simpleMessage("Use fingerprint"),
    "labelVersion" : MessageLookupByLibrary.simpleMessage("Version"),
    "labelWaitConnection" : MessageLookupByLibrary.simpleMessage("Connection..."),
    "labelWaitHostResponse" : MessageLookupByLibrary.simpleMessage("Waiting host response"),
    "labelWebConnectionRequest" : MessageLookupByLibrary.simpleMessage("Web requests connection"),
    "labelWriteNewNoteOnStartup" : MessageLookupByLibrary.simpleMessage("Write new note on startup"),
    "memoEmpty" : MessageLookupByLibrary.simpleMessage("Empty memo"),
    "memoError" : MessageLookupByLibrary.simpleMessage("Error occurred"),
    "orderByCreated" : MessageLookupByLibrary.simpleMessage("Created date"),
    "orderByUpdated" : MessageLookupByLibrary.simpleMessage("Updated date"),
    "orderCreatedAsc" : MessageLookupByLibrary.simpleMessage("Created date ascending"),
    "orderCreatedDes" : MessageLookupByLibrary.simpleMessage("Created date descending"),
    "orderType" : MessageLookupByLibrary.simpleMessage("Order type"),
    "orderTypeAsc" : MessageLookupByLibrary.simpleMessage("Ascending"),
    "orderTypeDes" : MessageLookupByLibrary.simpleMessage("Descending"),
    "resultCountMessage" : m2,
    "subtitleDebug" : MessageLookupByLibrary.simpleMessage("Debug"),
    "subtitleInfo" : MessageLookupByLibrary.simpleMessage("Info"),
    "subtitleNote" : MessageLookupByLibrary.simpleMessage("Note"),
    "subtitleQuickFolderClassification" : MessageLookupByLibrary.simpleMessage("Folder classification on write new note title"),
    "subtitleQuickMemoWriting" : MessageLookupByLibrary.simpleMessage("Create a memo using the default memo type"),
    "subtitleResultAppendType" : MessageLookupByLibrary.simpleMessage("Set extract text result append type"),
    "subtitleSecurity" : MessageLookupByLibrary.simpleMessage("Security"),
    "titleAddImage" : MessageLookupByLibrary.simpleMessage("Select image area to send"),
    "titleGuestConnection" : MessageLookupByLibrary.simpleMessage("Connect another device"),
    "titleHistory" : MessageLookupByLibrary.simpleMessage("History"),
    "titleHostConnection" : MessageLookupByLibrary.simpleMessage("Get connection code"),
    "titleResult" : MessageLookupByLibrary.simpleMessage("Process result"),
    "validationServiceHost" : MessageLookupByLibrary.simpleMessage("Error: service host is not empty"),
    "warnGenerateCode" : MessageLookupByLibrary.simpleMessage("If you close the screen before connecting from another device, you will not receive a connection request.")
  };
}
