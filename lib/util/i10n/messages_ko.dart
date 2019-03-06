// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ko locale. All the
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
  get localeName => 'ko';

  static m0(itemName) => "${itemName} 삭제됨";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "actionAddImage" : MessageLookupByLibrary.simpleMessage("이미지 추가"),
    "actionSendImage" : MessageLookupByLibrary.simpleMessage("이미지 보내기"),
    "actionSort" : MessageLookupByLibrary.simpleMessage("정렬"),
    "actionUndo" : MessageLookupByLibrary.simpleMessage("되돌리기"),
    "appName" : MessageLookupByLibrary.simpleMessage("sp_client"),
    "dialogDeleteItem" : MessageLookupByLibrary.simpleMessage("결과를 삭제할까요?"),
    "dialogSendImage" : MessageLookupByLibrary.simpleMessage("이미지 보내는 중..."),
    "imageFromCamera" : MessageLookupByLibrary.simpleMessage("사진 촬영"),
    "imageFromGallery" : MessageLookupByLibrary.simpleMessage("갤러리에서 선택"),
    "itemDeleted" : m0,
    "orderCreatedAsc" : MessageLookupByLibrary.simpleMessage("추가한 날짜 오름차순"),
    "orderCreatedDes" : MessageLookupByLibrary.simpleMessage("추가한 날짜 내림차순"),
    "titleHistory" : MessageLookupByLibrary.simpleMessage("기록"),
    "titleImageSelect" : MessageLookupByLibrary.simpleMessage("선택한 이미지"),
    "titleResult" : MessageLookupByLibrary.simpleMessage("결과"),
    "typeDate" : MessageLookupByLibrary.simpleMessage("날짜"),
    "typeFolder" : MessageLookupByLibrary.simpleMessage("폴더")
  };
}
