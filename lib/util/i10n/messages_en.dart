// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

// ignore: unnecessary_new
final messages = new MessageLookup();

// ignore: unused_element
final _keepAnalysisHappy = Intl.defaultLocale;

// ignore: non_constant_identifier_names
typedef MessageIfAbsent(String message_str, List args);

class MessageLookup extends MessageLookupByLibrary {
  get localeName => 'en';

  static m0(resultsCount) => "${resultsCount} result";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "actionAdd" : MessageLookupByLibrary.simpleMessage("Add"),
    "actionAddFolder" : MessageLookupByLibrary.simpleMessage("Add folder"),
    "actionAddImage" : MessageLookupByLibrary.simpleMessage("Add image"),
    "actionDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "actionEdit" : MessageLookupByLibrary.simpleMessage("Edit"),
    "actionMoveFolder" : MessageLookupByLibrary.simpleMessage("Move another folder"),
    "actionRemoveFolder" : MessageLookupByLibrary.simpleMessage("Remove folder"),
    "actionRename" : MessageLookupByLibrary.simpleMessage("Rename"),
    "actionRenameFolder" : MessageLookupByLibrary.simpleMessage("Rename folder"),
    "actionSendImage" : MessageLookupByLibrary.simpleMessage("Send image"),
    "actionSettings" : MessageLookupByLibrary.simpleMessage("Settings"),
    "actionSort" : MessageLookupByLibrary.simpleMessage("Sort"),
    "appName" : MessageLookupByLibrary.simpleMessage("sp_client"),
    "dialogDeleteFolder" : MessageLookupByLibrary.simpleMessage("All the histories in the folder are moved to the default folder. Delete folder?"),
    "dialogDeleteItem" : MessageLookupByLibrary.simpleMessage("Are you sure to delete?"),
    "dialogFolderSelect" : MessageLookupByLibrary.simpleMessage("Folder Select"),
    "dialogSendImage" : MessageLookupByLibrary.simpleMessage("Send image..."),
    "errorEmptyName" : MessageLookupByLibrary.simpleMessage("Error: name is not empty"),
    "folderDefault" : MessageLookupByLibrary.simpleMessage("Default"),
    "historyEmpty" : MessageLookupByLibrary.simpleMessage("Empty history"),
    "imageFromCamera" : MessageLookupByLibrary.simpleMessage("Take from camera"),
    "imageFromGallery" : MessageLookupByLibrary.simpleMessage("Select from gallery"),
    "orderCreatedAsc" : MessageLookupByLibrary.simpleMessage("Created date ascending"),
    "orderCreatedDes" : MessageLookupByLibrary.simpleMessage("Created date descending"),
    "resultCountMessage" : m0,
    "titleAddImage" : MessageLookupByLibrary.simpleMessage("Select image area to send"),
    "titleHistory" : MessageLookupByLibrary.simpleMessage("History"),
    "titleResult" : MessageLookupByLibrary.simpleMessage("Result")
  };
}
