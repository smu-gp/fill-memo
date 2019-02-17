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

  static m0(itemName) => "${itemName} is deleted";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "actionAddImage" : MessageLookupByLibrary.simpleMessage("Add Image"),
    "actionSendImage" : MessageLookupByLibrary.simpleMessage("Send Image"),
    "actionSort" : MessageLookupByLibrary.simpleMessage("Sort"),
    "actionUndo" : MessageLookupByLibrary.simpleMessage("Undo"),
    "appName" : MessageLookupByLibrary.simpleMessage("sp_client"),
    "dialogSendImage" : MessageLookupByLibrary.simpleMessage("Send image..."),
    "imageFromCamera" : MessageLookupByLibrary.simpleMessage("Take from camera"),
    "imageFromGallery" : MessageLookupByLibrary.simpleMessage("Select from gallery"),
    "itemDeleted" : m0,
    "orderCreatedAsc" : MessageLookupByLibrary.simpleMessage("Created date ascending"),
    "orderCreatedDes" : MessageLookupByLibrary.simpleMessage("Created date descending"),
    "titleHistory" : MessageLookupByLibrary.simpleMessage("History"),
    "titleImageSelect" : MessageLookupByLibrary.simpleMessage("Selected Image"),
    "titleResult" : MessageLookupByLibrary.simpleMessage("Result")
  };
}
