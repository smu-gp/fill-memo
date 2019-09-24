import 'dart:async';

import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/service/services.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/util.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/list_item.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:rich_text_editor/rich_text_editor.dart';
import 'package:uuid/uuid.dart';

import 'process_result_screen.dart';

enum _MarkdownToolbarAction {
  formatBold,
  formatItalic,
  moveCursorLeft,
  moveCursorRight,
  deleteLine,
  addImage,
  setH1,
  setH2,
  setH3,
  setQuote,
  setCode,
  deleteAll,
  addLink,
  addList,
  addListNumbered,
  addDivider,
}

class MemoMarkdownScreen extends StatefulWidget {
  final Memo memo;

  MemoMarkdownScreen(
    this.memo, {
    Key key,
  }) : super(key: key);

  @override
  _MemoMarkdownScreenState createState() => _MemoMarkdownScreenState();
}

class _MemoMarkdownScreenState extends State<MemoMarkdownScreen> {
  TextEditingController _editTitleTextController;
  SpannableTextEditingController _editContentTextController;

  StreamSubscription _uploadSubscription;

  MemoBloc _memoBloc;
  PreferenceRepository _preferenceRepository;

  String _content;
  bool _showProgress = false;
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();
    _memoBloc = BlocProvider.of<MemoBloc>(context);
    _preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);

    _editTitleTextController =
        TextEditingController(text: widget.memo.title ?? "");
    _editContentTextController =
        SpannableTextEditingController(text: widget.memo.content ?? "");
    _content = widget.memo.content ?? "";

    _editContentTextController.addListener(() {
      setState(() {
        _content = _editContentTextController.value.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget progressBar = Visibility(
      visible: _showProgress,
      child: SizedBox(
        child: LinearProgressIndicator(
          backgroundColor: AppColors.accentColor.withOpacity(0.2),
          value: _progressValue,
        ),
        height: 4,
      ),
    );

    Widget titleTextField = Container(
      height: kToolbarHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: _TitleEditText(controller: _editTitleTextController),
    );

    Widget contentTextField = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: _ContentEditText(
        controller: _editContentTextController,
        autofocus: widget.memo.id == null,
      ),
    );

    Widget contentMarkdown = Markdown(
      data: _content,
      onTapLink: (url) => launchUrl(url),
    );

    Widget child;
    if (Util.isLarge(context)) {
      child = Column(
        children: <Widget>[
          progressBar,
          titleTextField,
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: contentTextField),
                VerticalDivider(),
                Expanded(child: contentMarkdown),
              ],
            ),
          ),
          _buildBottomToolbar(),
        ],
      );
    } else {
      child = Column(
        children: <Widget>[
          progressBar,
          titleTextField,
          Expanded(child: contentTextField),
          Divider(),
          Expanded(child: contentMarkdown),
          _buildBottomToolbar(),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: _editContentTextController.canUndo()
                ? () {
                    _editContentTextController.undo();
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: _editContentTextController.canRedo()
                ? () {
                    _editContentTextController.redo();
                  }
                : null,
          ),
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              _showPreviewScreen();
            },
          )
        ],
      ),
      body: child,
    );
  }

  @override
  void dispose() {
    _updateMemo();
    _editContentTextController.dispose();
    _editTitleTextController.dispose();
    super.dispose();
  }

  Widget _buildBottomToolbar() {
    Map<_MarkdownToolbarAction, IconData> actions = {
      _MarkdownToolbarAction.moveCursorLeft: Icons.keyboard_arrow_left,
      _MarkdownToolbarAction.moveCursorRight: Icons.keyboard_arrow_right,
      _MarkdownToolbarAction.formatBold: Icons.format_bold,
      _MarkdownToolbarAction.formatItalic: Icons.format_italic,
      _MarkdownToolbarAction.setH1: Icons.looks_one,
      _MarkdownToolbarAction.setH2: Icons.looks_two,
      _MarkdownToolbarAction.setH3: Icons.looks_3,
      _MarkdownToolbarAction.setQuote: Icons.format_quote,
      _MarkdownToolbarAction.setCode: Icons.code,
      _MarkdownToolbarAction.addLink: Icons.link,
      _MarkdownToolbarAction.addList: Icons.list,
      _MarkdownToolbarAction.addListNumbered: Icons.format_list_numbered,
      _MarkdownToolbarAction.addDivider: Icons.linear_scale,
      _MarkdownToolbarAction.addImage: Icons.image,
      _MarkdownToolbarAction.deleteLine: Icons.delete_sweep,
      _MarkdownToolbarAction.deleteAll: Icons.delete,
    };

    return Material(
      elevation: 8.0,
      child: Container(
        height: 48.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: actions.keys.map((key) {
              return IconButton(
                icon: Icon(actions[key]),
                onPressed: () => _handleActions(key),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _handleActions(_MarkdownToolbarAction action) {
    switch (action) {
      case _MarkdownToolbarAction.formatBold:
        return _wrapContent('**');
      case _MarkdownToolbarAction.formatItalic:
        return _wrapContent('*');
      case _MarkdownToolbarAction.moveCursorLeft:
        return _moveCursor(true);
      case _MarkdownToolbarAction.moveCursorRight:
        return _moveCursor(false);
      case _MarkdownToolbarAction.deleteLine:
        return _lineDelete();
      case _MarkdownToolbarAction.addImage:
        return _showInsertImageSheet();
      case _MarkdownToolbarAction.setH1:
        return _prefixContent('# ');
      case _MarkdownToolbarAction.setH2:
        return _prefixContent('## ');
      case _MarkdownToolbarAction.setH3:
        return _prefixContent('### ');
      case _MarkdownToolbarAction.setQuote:
        return _prefixContent('> ');
      case _MarkdownToolbarAction.setCode:
        return _wrapContent('`');
      case _MarkdownToolbarAction.deleteAll:
        return _clear();
      case _MarkdownToolbarAction.addLink:
        return _linkContent();
      case _MarkdownToolbarAction.addList:
        return _prefixContent('- ');
      case _MarkdownToolbarAction.addListNumbered:
        return _prefixContent('1. ');
      case _MarkdownToolbarAction.addDivider:
        return _prefixContent('***');
    }
  }

  void _moveCursor(bool direction) {
    var text = _editContentTextController.value.text;
    var selection = _editContentTextController.selection;

    if (direction) {
      if (selection.start == 0)
        return;
      else {
        _editContentTextController.value = _editContentTextController.value
            .copyWith(
                selection:
                    TextSelection.collapsed(offset: selection.start - 1));
      }
    } else {
      if (selection.start == text.length)
        return;
      else {
        _editContentTextController.value = _editContentTextController.value
            .copyWith(
                selection:
                    TextSelection.collapsed(offset: selection.start + 1));
      }
    }
  }

  void _lineDelete() {
    var text = _editContentTextController.value.text;
    var selection = _editContentTextController.selection;

    int lineStart = _findLineStart(selection.end, text);
    int lineEnd = _findLineEnd(selection.end, text);

    String before = selection.textBefore(text).substring(0, lineStart);
    String after = text.substring(lineEnd, text.length);

    _editContentTextController.value = _editContentTextController.value
        .copyWith(
            text: before + after,
            selection: TextSelection.collapsed(offset: lineStart));
  }

  Future _insertImage(
    ImageObject imageObject,
    bool enableTextRecognition,
    TextSelection selection,
  ) async {
    if (enableTextRecognition) {
      try {
        var results = await _uploadProcessServer(imageObject);
        if (results != null && results.isNotEmpty) {
          await _showProcessResults(results, selection);
        } else {
          await _showProcessNoResults();
        }
      } catch (e) {
        Navigator.pop(context); // Hide progress dialog
        await _showProcessErrorDialog(e);
      }
    } else {
      setState(() {
        _showProgress = true;
      });

      _uploadSubscription?.cancel();
      _uploadSubscription = _uploadFirebaseStorage(imageObject).listen((event) {
        if (event.state == TaskState.progress) {
          setState(() {
            _progressValue = event.bytesTransferred / event.totalBytes;
          });
        } else if (event.state == TaskState.success) {
          var downloadUrl = event.downloadUrl;
          if (downloadUrl != null && downloadUrl.isNotEmpty) {
            String contentText = _editContentTextController.text;
            String before = selection.textBefore(contentText);
            String inner = '![link](' + downloadUrl + ')';
            String after = '' + selection.textAfter(contentText);
            _editContentTextController.text = before + inner + after;
          }

          setState(() {
            _progressValue = 0;
            _showProgress = false;
          });
        }
      });
    }
  }

  void _clear() {
    _editContentTextController.clear();
  }

  void _linkContent() {
    var selection = _editContentTextController.selection;
    var text = _editContentTextController.value.text;
    String link = '[link](url)';

    String before = selection.textBefore(text);
    String inner = link;
    String after = '' + selection.textAfter(text);

    _editContentTextController.value =
        _editContentTextController.value.copyWith(
      text: before + inner + after,
      selection: TextSelection(
          baseOffset: selection.start + link.length - 4,
          extentOffset: selection.start + link.length - 1),
    );
  }

  void _wrapContent(String content) {
    var selection = _editContentTextController.selection;
    var text = _editContentTextController.value.text;

    String before = selection.textBefore(text);
    String inner = " ";
    if (content.contains('~') || content.contains('*') || content.contains('`'))
      inner = content + selection.textInside(text) + content;
    else
      inner = content + selection.textInside(text);
    String after = selection.textAfter(text);

    _editContentTextController.value = _editContentTextController.value
        .copyWith(
            text: before + inner + after,
            selection: TextSelection.collapsed(
                offset: selection.start + content.length));
  }

  int _findLineStart(int cursor, String text) {
    int i = cursor - 1;
    for (; i >= 0; i--) {
      if (text[i] == '\n') break;
    }
    return i + 1;
  }

  int _findLineEnd(int cursor, String text) {
    int i = _findLineStart(cursor, text);
    while (true) {
      if (i == text.length) break;
      if (text[i] == '\n') break;
      i++;
    }
    return i;
  }

  void _prefixContent(String content) {
    var text = _editContentTextController.value.text;
    var selection = _editContentTextController.selection;

    int lineStart = _findLineStart(selection.start, text);
    String before = selection.textBefore(text);
    String inner = selection.textInside(text);
    String after = selection.textAfter(text);
    String bf = " ";
    if (text.substring(lineStart, selection.end).startsWith(content)) {
      bf = before
          .substring(lineStart, selection.start)
          .replaceFirst(content, '');
      if (lineStart == 0)
        before = bf;
      else {
        before = before.substring(0, lineStart);
        before += bf;
      }
      _editContentTextController.value = _editContentTextController.value
          .copyWith(
              text: before + inner + after,
              selection: TextSelection.collapsed(offset: before.length));
    } else {
      if (lineStart == 0)
        bf = content + before;
      else {
        String st = before.substring(0, lineStart);
        String s = before.substring(lineStart, selection.start);
        bf = st + content + s;
      }
      before = bf;
      _editContentTextController.value = _editContentTextController.value
          .copyWith(
              text: before + inner + after,
              selection: TextSelection.collapsed(
                  offset: selection.start + content.length));
    }
  }

  void _updateMemo() {
    var titleText = _editTitleTextController.text;
    var contentText = _editContentTextController.text;

    var memo = widget.memo;
    var isChanged = memo.title != titleText || memo.content != contentText;

    memo.title = titleText.isNotEmpty ? titleText : null;
    memo.content = contentText.isNotEmpty ? contentText : null;

    if (isChanged) {
      memo.updatedAt = DateTime.now().millisecondsSinceEpoch;
    }

    var isValid = memo.title != null || memo.content != null;

    if (widget.memo.id != null) {
      if (isValid) {
        if (isChanged) {
          _memoBloc.dispatch(UpdateMemo(memo));
        }
      } else {
        _memoBloc.dispatch(DeleteMemo(memo));
      }
    } else {
      if (isValid) {
        _memoBloc.dispatch(AddMemo(memo));
      }
    }
  }

  Future<List<ProcessResult>> _uploadProcessServer(
    ImageObject imageObject,
  ) async {
    _showProgressDialog();

    var host = _preferenceRepository.getString(AppPreferences.keyServiceHost) ??
        defaultServiceHost;

    var results = await sendImage(
      imageObject: imageObject,
      baseUrl: processingServiceUrl(host),
    );

    Navigator.pop(context); // Hide progress dialog
    return results;
  }

  Stream<UploadTaskEvent> _uploadFirebaseStorage(ImageObject imageObject) {
    var userId;
    final authState = BlocProvider.of<AuthBloc>(context).currentState;
    if (authState is Authenticated) {
      userId = authState.uid;
    }
    final uuid = Uuid().v1();
    final ext = imageObject.path.split(".")[1];

    return ImageStorage.putFile(
      userId: userId,
      name: '$uuid.$ext',
      file: imageObject.file,
    );
  }

  void _showInsertImageSheet() async {
    TextSelection currentSelection = _editContentTextController.selection;
    _InsertImageResult result = await showModalBottomSheet(
      context: context,
      builder: (context) => _InsertImageSheet(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
    );

    if (result != null && result.imageObject != null) {
      _insertImage(
        result.imageObject,
        result.enableTextRecognition,
        currentSelection,
      );
    }
  }

  Future _showProgressDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                width: 24.0,
              ),
              Text(AppLocalizations.of(context).dialogSendImage)
            ],
          ),
        );
      },
    );
  }

  Future _showProcessErrorDialog(Object e) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).labelErrorOccurred),
          content: Text(e.toString()),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).labelClose),
            ),
          ],
        );
      },
    );
  }

  Future _showProcessResults(
    List<ProcessResult> results,
    TextSelection selection,
  ) async {
    var selectedItems;
    if (Util.isLarge(context)) {
      selectedItems = await showDialog(
        context: context,
        builder: (context) => ProcessResultScreen(results),
      );
    } else {
      selectedItems = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProcessResultScreen(results)),
      );
    }

    if (selectedItems != null) {
      var prefResultAppendType =
          _preferenceRepository.getString(AppPreferences.keyResultAppendType) ??
              typeSpace;
      var appendValue = "";
      if (prefResultAppendType == typeSpace) {
        appendValue = " ";
      } else if (prefResultAppendType == typeNewline) {
        appendValue = "\n";
      }

      var processedText = "";

      selectedItems.forEach((result) {
        processedText += (result as ProcessResult).content + appendValue;
      });

      var text = _editContentTextController.text;
      if (selection.isNormalized && selection.isValid) {
        text = selection.textBefore(text) +
            selection.textInside(text) +
            processedText +
            selection.textAfter(text);
      } else {
        text = text += processedText;
      }
      _editContentTextController.text = text;
    }
  }

  Future _showProcessNoResults() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).titleResult),
          content: Text(AppLocalizations.of(context).labelNoProcessResult),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).labelClose),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future _showPreviewScreen() async {
    var titleText = _editTitleTextController.text;
    var contentText = _editContentTextController.text;

    Navigator.push(
      context,
      Routes().markdownPreviewMemo(
        title: titleText,
        content: contentText,
      ),
    );
  }
}

class _ContentEditText extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;

  const _ContentEditText({
    Key key,
    @required this.controller,
    this.autofocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextField(
        autofocus: autofocus,
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          hintText: AppLocalizations.of(context).hintInputNote,
        ),
      ),
    );
  }
}

class _TitleEditText extends StatelessWidget {
  final TextEditingController controller;

  _TitleEditText({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextField(
        autofocus: false,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          hintText: AppLocalizations.of(context).hintInputTitle,
        ),
        style: Theme.of(context).textTheme.headline,
        maxLines: 1,
        onChanged: (value) {},
      ),
    );
  }
}

class _InsertImageSheet extends StatefulWidget {
  @override
  _InsertImageSheetState createState() => _InsertImageSheetState();
}

class _InsertImageSheetState extends State<_InsertImageSheet> {
  bool _enableTextRecognition = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        SwitchListItem(
          title: AppLocalizations.of(context).actionAddTextFromImage,
          value: _enableTextRecognition,
          onChanged: (bool value) {
            setState(() {
              _enableTextRecognition = value;
            });
          },
        ),
        Divider(),
        ListItem(
          leading: Icon(
            OMIcons.image,
            color: Theme.of(context).accentColor,
          ),
          title: AppLocalizations.of(context).imageFromGallery,
          onTap: () => _handleMenuTapped(ImageSource.gallery),
        ),
        if (!kIsWeb)
          ListItem(
            leading: Icon(
              OMIcons.photoCamera,
              color: Theme.of(context).accentColor,
            ),
            title: AppLocalizations.of(context).imageFromCamera,
            onTap: () => _handleMenuTapped(ImageSource.camera),
          ),
      ],
    );
  }

  Future _handleMenuTapped(ImageSource source) async {
    var imageObject = await pickImage(source);
    Navigator.pop(
      context,
      _InsertImageResult(
        imageObject: imageObject,
        enableTextRecognition: _enableTextRecognition,
      ),
    );
  }
}

class _InsertImageResult {
  final ImageObject imageObject;
  final bool enableTextRecognition;

  _InsertImageResult({this.imageObject, this.enableTextRecognition});

  @override
  String toString() {
    return '$runtimeType(imageObject: $imageObject, enableTextRecognition: $enableTextRecognition)';
  }
}
