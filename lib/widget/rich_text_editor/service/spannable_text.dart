import 'package:diff_match_patch/DiffMatchPatch.dart';
import 'package:flutter/widgets.dart';
import 'package:sp_client/widget/rich_text_editor/util/spannable_list.dart';
import 'package:sp_client/widget/rich_text_editor/util/spannable_style.dart';

@immutable
class SpannableTextValue {
  final String sourceText;
  final TextSelection selection;
  final SpannableStyle composingStyle;

  const SpannableTextValue({
    this.sourceText = '',
    this.selection = const TextSelection.collapsed(offset: -1),
    this.composingStyle,
  }) : assert(sourceText != null);

  SpannableTextValue copyWith({
    String text,
    TextSelection selection,
    SpannableStyle composingStyle,
  }) {
    return SpannableTextValue(
      sourceText: text ?? this.sourceText,
      selection: selection ?? this.selection,
      composingStyle: composingStyle ?? this.composingStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpannableTextValue &&
          runtimeType == other.runtimeType &&
          sourceText == other.sourceText &&
          selection == other.selection &&
          composingStyle == other.composingStyle;

  @override
  int get hashCode =>
      sourceText.hashCode ^ selection.hashCode ^ composingStyle.hashCode;

  @override
  String toString() {
    return '$runtimeType(sourceText: $sourceText, selection: $selection, composingStyle: $composingStyle)';
  }
}

class SpannableTextController extends ValueNotifier<SpannableTextValue> {
  SpannableList _list;

  SpannableTextController({
    String sourceText = '',
    SpannableList list,
  })  : _list = list ??
            SpannableList.fromList(
              List.filled(sourceText.length, 0, growable: true),
            ),
        super(SpannableTextValue(sourceText: sourceText));

  SpannableTextController.fromJson({
    String sourceText = '',
    @required String jsonText,
  })  : _list = SpannableList.fromJson(jsonText),
        super(SpannableTextValue(sourceText: sourceText));

  SpannableStyle get composingStyle => value.composingStyle;

  set composingStyle(SpannableStyle newComposingStyle) {
    value = value.copyWith(composingStyle: newComposingStyle);
  }

  String get sourceText => value.sourceText;

  set sourceText(String newText) {
    var textChange = _calculateTextChange(sourceText, newText);
    _updateList(textChange);
    value = value.copyWith(text: newText);
  }

  TextSelection get selection => value.selection;

  set selection(TextSelection newSelection) {
    value = value.copyWith(selection: newSelection);
  }

  void clear() {
    _list.clear();
    value = SpannableTextValue();
  }

  void clearComposingStyle() {
    value = value.copyWith(composingStyle: SpannableStyle());
  }

  TextSpan getTextSpan(TextStyle defaultStyle) =>
      _list.toTextSpan(value.sourceText, defaultStyle: defaultStyle);

  String getJson() => _list.toJson();

  SpannableStyle getSelectionStyle(TextSelection selection) {
    if (selection.isValid && selection.isNormalized) {
      SpannableStyle style = SpannableStyle();
      for (var offset = selection.start; offset < selection.end; offset++) {
        final current = _list.index(offset);
        style.setStyle(style.style | current.style);
        style.clearForegroundColor();
        style.clearBackgroundColor();
      }
      return style;
    }
    return null;
  }

  void updateSelectionStyle(TextSelection selection, ModifyCallback callback) {
    if (selection.isValid && selection.isNormalized) {
      for (var offset = selection.start; offset < selection.end; offset++) {
        _list.modify(offset, callback);
      }
      notifyListeners();
    }
  }

  void _updateList(TextChange change) {
    if (change != null) {
      var style;
      if (change.operation == Operation.insert) {
        style = (composingStyle ?? SpannableStyle()).copy();
      }

      for (var index = 0; index < change.length; index++) {
        if (change.operation == Operation.insert) {
          _list.insert(change.offset + index, style);
        } else if (change.operation == Operation.delete) {
          _list.delete(change.offset);
        }
      }
    }
  }

//  void _applyLinkStyle() {
//    var regExp = RegExp(
//      r"(https?|ftp)://([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?",
//      caseSensitive: false,
//    );
//
//    var matches = regExp.allMatches(text);
//    if (matches.isNotEmpty) {
//      matches.forEach((match) {
//        for (var offset = match.start; offset < match.end; offset++) {
//          _list.modify(offset, (style) => SpannableStyle(value: styleLink));
//        }
//      });
//    }
//  }

  /// TODO 끝이 아닌 중간에서 수정할때 입력한 내용이 바로 앞과 같은 내용이라면
  ///      스타일이 잘못 적용되는 문제가 있음.
  TextChange _calculateTextChange(String oldText, String newText) {
    if (oldText == null) {
      return null;
    }

    var dmp = DiffMatchPatch();
    var diffList = dmp.diff_main(oldText, newText);
    var operation, length;
    var offset = 0;
    for (var index = 0; index < diffList.length; index++) {
      final diff = diffList[index];
      if (diff.operation == Operation.equal) {
        offset += diff.text.length;
      } else if (diff.operation == Operation.insert) {
        if (index + 1 < diffList.length) {
          final nextDiff = diffList[index + 1];
          if (nextDiff.operation == Operation.delete) {
            if (nextDiff.text.length == diff.text.length) break;
            if (nextDiff.text.length < diff.text.length) {
              operation = Operation.delete;
              length = diff.text.length - nextDiff.text.length;
              break;
            }
          }
        }
        operation = Operation.insert;
        length = diff.text.length;
        break;
      } else if (diff.operation == Operation.delete) {
        if (index + 1 < diffList.length) {
          final nextDiff = diffList[index + 1];

          if (nextDiff.operation == Operation.insert) {
            if (nextDiff.text.length == diff.text.length) break;
            if (nextDiff.text.length > diff.text.length) {
              offset++;
              operation = Operation.insert;
              length = nextDiff.text.length - diff.text.length;
              break;
            }
          }
        }
        operation = Operation.delete;
        length = diff.text.length;
        break;
      }
    }

    if (operation != null) {
      return TextChange(operation, offset, length);
    } else {
      return null;
    }
  }
}

@immutable
class TextChange {
  final Operation operation;
  final int offset;
  final int length;

  TextChange(this.operation, this.offset, this.length);

  @override
  String toString() {
    return '$runtimeType(operation: $operation, offset: $offset, length: $length)';
  }
}
