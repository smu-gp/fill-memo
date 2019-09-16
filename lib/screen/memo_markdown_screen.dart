import 'dart:io';

import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/util/util.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/list_item.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
  TextEditingController _editingContentController;
  TextEditingController _editingTitleController;
  String content = "";
  bool _showProgress = false;
  double _progressValue = 0;
  MemoBloc _memoBloc;

  PreferenceRepository _preferenceRepository;
  List<String> _memoContentImages;

  @override
  void initState() {
    super.initState();
    _editingContentController =
        TextEditingController(text: widget.memo.content ?? "");
    _editingTitleController =
        TextEditingController(text: widget.memo.title ?? "");
    _preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);
    _memoBloc = BlocProvider.of<MemoBloc>(context);
    _editingContentController.addListener(() {
      setState(() {
        content = _editingContentController.value.text;
      });
    });
    _memoContentImages = []..addAll(widget.memo.contentImages ?? []);
  }

  @override
  Widget build(BuildContext context) {
    if (Util.isLarge(context)) {
      return tabletUI(context);
    } else {
      return phoneUI(context);
    }
  }

  Widget tabletUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("markdown"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              _showPreviewScreen();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Markdown(
                    //data: content,
                    data: _editingContentController.text,
                  ),
                  flex: 1,
                ),
                VerticalDivider(),
                Expanded(
                    child: TextField(
                      controller: _editingContentController,
                      enableInteractiveSelection: true,
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      textInputAction: TextInputAction.newline,
                      textAlign: TextAlign.start,
                      maxLengthEnforced: true,
                      maxLines: 100,
                      minLines: 10,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'input text'),
                    ),
                    flex: 1),
              ],
            ),
          ),
          Material(
            elevation: 8.0,
            child: Container(
              height: 48.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.format_bold),
                      onPressed: () {
                        _wrapContent('**');
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.format_italic),
                        onPressed: () {
                          _wrapContent('*');
                        }),
                    IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () {
                        _insertImageDialog();
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.looks_one),
                        onPressed: () {
                          _prefixContent('# ');
                        }),
                    IconButton(
                        icon: Icon(Icons.looks_two),
                        onPressed: () {
                          _prefixContent('## ');
                        }),
                    IconButton(
                        icon: Icon(Icons.looks_3),
                        onPressed: () {
                          _prefixContent('### ');
                        }),
                    IconButton(
                        icon: Icon(Icons.format_strikethrough),
                        onPressed: () {
                          _wrapContent('~~');
                        }),
                    IconButton(
                      icon: Icon(Icons.format_quote),
                      onPressed: () {
                        _prefixContent('> ');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.code),
                      onPressed: () {
                        _wrapContent('`');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _clear();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.link),
                      onPressed: () {
                        _linkContent();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.list),
                      onPressed: () {
                        _prefixContent('- ');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.format_list_numbered),
                      onPressed: () {
                        _prefixContent('1. ');
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget phoneUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("markdown"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () {
              _showPreviewScreen();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: _showProgress,
            child: SizedBox(
              child: LinearProgressIndicator(
                backgroundColor: AppColors.accentColor.withOpacity(0.2),
                value: _progressValue,
              ),
              height: 4,
            ),
          ),
          Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.only(left: 16.0),
            child: _TitleEditText(controller: _editingTitleController),
          ),
          Expanded(
            child: Markdown(
              data: _editingContentController.text,
            ),
            flex: 1,
          ),
          Divider(),
          Expanded(
            child: TextField(
              controller: _editingContentController,
              enableInteractiveSelection: true,
              keyboardType: TextInputType.multiline,
              maxLength: null,
              textInputAction: TextInputAction.newline,
              textAlign: TextAlign.start,
              maxLengthEnforced: true,
              maxLines: 100,
              minLines: 10,
              autofocus: true,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'input text'),
            ),
            flex: 1,
          ),
          Material(
            elevation: 8.0,
            child: Container(
              height: 48.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.format_bold),
                      onPressed: () {
                        _wrapContent('**');
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.format_italic),
                        onPressed: () {
                          _wrapContent('*');
                        }),
                    IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () {
                        _insertImageDialog();
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.looks_one),
                        onPressed: () {
                          _prefixContent('# ');
                        }),
                    IconButton(
                        icon: Icon(Icons.looks_two),
                        onPressed: () {
                          _prefixContent('## ');
                        }),
                    IconButton(
                        icon: Icon(Icons.looks_3),
                        onPressed: () {
                          _prefixContent('### ');
                        }),
                    IconButton(
                        icon: Icon(Icons.format_strikethrough),
                        onPressed: () {
                          _wrapContent('~~');
                        }),
                    IconButton(
                      icon: Icon(Icons.format_quote),
                      onPressed: () {
                        _prefixContent('> ');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.code),
                      onPressed: () {
                        _wrapContent('`');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _clear();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.link),
                      onPressed: () {
                        _linkContent();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.list),
                      onPressed: () {
                        _prefixContent('- ');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.format_list_numbered),
                      onPressed: () {
                        _prefixContent('1. ');
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _insertImageDialog() async {
    var selection = _editingContentController.selection;
    var text = _editingContentController.text;
    TextEditingController controller = TextEditingController();
    var result = await showDialog(
        context: context,
        builder: (_) => urlDialog(
              controller: controller,
              preferenceRepository: _preferenceRepository,
            ));
    if (result != "") {
      String before = selection.textBefore(text);
      String inner = '![link](' + result + ')';
      String after = '' + selection.textAfter(text);
      _editingContentController.value =
          _editingContentController.value.copyWith(
        text: before + inner + after,
        selection: selection,
      );
    } else {
      _editingContentController.value =
          _editingContentController.value.copyWith(
        text: text,
        selection: selection,
      );
    }
  }

  Future _showPreviewScreen() async {
    await Navigator.push(
      context,
      Routes().markdownPreviewMemo(content: content),
    );
    setState(() {});
  }

  void _clear() {
    _editingContentController.clear();
  }

  Future _showImageSettingBottomSheet() async {
    _AddImageSheetResult result = await showModalBottomSheet(
        elevation: 1.0,
        context: context,
        builder: (context) => imageSettingBottomSheet(
              controller: _editingContentController,
            ));
    if (result != null && result.file != null) {
      _addImage(result.file);
    }
  }

  void _linkContent() {
    var selection = _editingContentController.selection;
    var text = _editingContentController.value.text;
    String link = '[link](url)';

    String before = selection.textBefore(text);
    String inner = link;
    String after = '' + selection.textAfter(text);

    _editingContentController.value = _editingContentController.value.copyWith(
      text: before + inner + after,
      selection: TextSelection(
          baseOffset: selection.start + link.length - 4,
          extentOffset: selection.start + link.length - 1),
    );
  }

  void _wrapContent(String content) {
    var selection = _editingContentController.selection;
    var text = _editingContentController.value.text;

    String before = selection.textBefore(text);
    String inner = " ";
    if (content.contains('~') || content.contains('*') || content.contains('`'))
      inner = content + selection.textInside(text) + content;
    else
      inner = content + selection.textInside(text);
    String after = selection.textAfter(text);

    _editingContentController.value = _editingContentController.value.copyWith(
        text: before + inner + after,
        selection:
            TextSelection.collapsed(offset: selection.start + content.length)
        //selection: TextSelection(baseOffset: selection.start, extentOffset: selection.end + (content.length) * 2)
        );
  }

  int _findLineStart(int cursor, String text) {
    int i = cursor - 1;
    for (; i >= 0; i--) {
      if (text[i] == '\n') break;
    }
    return i + 1;
  }

  void _prefixContent(String content) {
    var text = _editingContentController.value.text;
    var selection = _editingContentController.selection;

    int linestart = _findLineStart(selection.end, text);
    String before = selection.textBefore(text);
    String after = selection.textAfter(text);
    String bf = " ";
    print(text.length);
    print(linestart);

    if (text.substring(linestart, selection.end).startsWith(content)) {
      print(linestart);
      bf = before
          .substring(linestart, selection.start)
          .replaceFirst(content, '');
      if (linestart == 0)
        before = bf;
      else {
        before = before.substring(0, linestart);
        before += bf;
      }
      _editingContentController.value = _editingContentController.value
          .copyWith(
              text: before + after,
              selection: TextSelection.collapsed(offset: before.length));
    } else {
      if (linestart == 0)
        bf = content + before;
      else {
        String st = before.substring(0, linestart);
        String s = before.substring(linestart, selection.start);
        bf = st + content + s;
      }
      before = bf;
      _editingContentController.value = _editingContentController.value
          .copyWith(
              text: before + after,
              selection: TextSelection.collapsed(
                  offset: selection.start + content.length));
    }
  }

  Future _addImage(File file) async {
    _uploadFirebaseStorage(file);
  }

  Future _uploadFirebaseStorage(File imageFile) async {
    final userId = _preferenceRepository.getString(AppPreferences.keyUserId);
    final uuid = Uuid().v1();
    final ext = imageFile.path.split(".")[1];
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child(userId).child('$uuid.$ext');
    final uploadTask = storageRef.putFile(imageFile);

    setState(() {
      _showProgress = true;
    });

    await for (final event in uploadTask.events) {
      if (event.type == StorageTaskEventType.progress) {
        setState(() {
          _progressValue =
              event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
          debugPrint(_progressValue.toString());
        });
      } else if (event.type == StorageTaskEventType.success) {
        final downloadURL = await event.snapshot.ref.getDownloadURL();
        _memoContentImages.add(downloadURL);
        setState(() {
          _progressValue = 0;
          _showProgress = false;
        });
      }
    }
  }

  void _updateMarkdownMemo() {
    var memo = widget.memo;
    var titleText = _editingTitleController.text;
    var contentText = content;

    var isChanged = memo.title != titleText || memo.content != contentText;

    memo.title = titleText.isNotEmpty ? titleText : null;
    memo.content = contentText.isNotEmpty ? contentText : "";
    memo.contentImages = _memoContentImages;

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

  @override
  void dispose() {
    _updateMarkdownMemo();
    _editingContentController.dispose();
    _editingTitleController.dispose();
    super.dispose();
  }
}

class urlDialog extends StatefulWidget {
  final TextEditingController controller;
  final PreferenceRepository preferenceRepository;

  urlDialog({
    Key key,
    this.controller,
    this.preferenceRepository,
  }) : super(key: key);

  @override
  _urlDialogState createState() => _urlDialogState();
}

class _urlDialogState extends State<urlDialog> {
  TextEditingController _controller;
  PreferenceRepository _preferenceRepository;
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _preferenceRepository = widget.preferenceRepository;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
      title: Text('Input URL'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            enableInteractiveSelection: true,
            controller: _controller,
            decoration: InputDecoration(hintText: 'url'),
          ),
          ListItem(
              leading: Icon(
                Icons.folder,
                color: Colors.deepOrangeAccent,
              ),
              title: 'Browse local repository',
              onTap: () async {
                var file = await _handleMenuTapped(ImageSource.gallery);
                if (file != null) {
                  var imageUrl = await _uploadFirebaseStorage(file);

                  _controller.text = imageUrl;
                }
              }),
          ListItem(
              leading: Icon(
                Icons.photo_camera,
                color: Colors.deepOrangeAccent,
              ),
              title: 'Camera',
              onTap: () async {
                var file = await _handleMenuTapped(ImageSource.camera);
                if (file != null) {
                  var imageUrl = await _uploadFirebaseStorage(file);

                  _controller.text = imageUrl;
                }
              })
        ],
      ),
      actions: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('SUBMIT'),
          onPressed: () {
            Navigator.pop(context, _controller.text);
          },
        ),
      ],
    );
  }

  Future _handleMenuTapped(ImageSource source) async {
    var file = await ImagePicker.pickImage(source: source);
    return file;
  }

  Future _uploadFirebaseStorage(File imageFile) async {
    final userId = _preferenceRepository.getString(AppPreferences.keyUserId);
    final uuid = Uuid().v1();
    final ext = imageFile.path.split(".")[1];
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child(userId).child('$uuid.$ext');
    final uploadTask = storageRef.putFile(imageFile);

    await for (final event in uploadTask.events) {
      if (event.type == StorageTaskEventType.progress) {
        print("progerss");
        if (mounted) {
          setState(() {
            _progressValue =
                event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
            debugPrint(_progressValue.toString());
          });
        }
      } else if (event.type == StorageTaskEventType.success) {
        print("succe");
        final downloadURL = await event.snapshot.ref.getDownloadURL();
        return downloadURL;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

class imageSettingBottomSheet extends StatefulWidget {
  final TextEditingController controller;

  imageSettingBottomSheet({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _imageSettingBottomSheetState createState() =>
      _imageSettingBottomSheetState();
}

class _imageSettingBottomSheetState extends State<imageSettingBottomSheet> {
  TextEditingController _urlController;
  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = widget.controller;
    _urlController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        children: <Widget>[
          ListItem(
            leading: Icon(
              Icons.link,
              color: Colors.deepOrangeAccent,
            ),
            title: 'Browse URL',
            onTap: () => _urlContent(),
          ),
          ListItem(
            leading: Icon(
              Icons.folder,
              color: Colors.deepOrangeAccent,
            ),
            title: 'Browse local repository',
            onTap: () => _handleMenuTapped(ImageSource.gallery),
          ),
          ListItem(
            leading: Icon(
              Icons.photo_camera,
              color: Colors.deepOrangeAccent,
            ),
            title: 'Camera',
            onTap: () => _handleMenuTapped(ImageSource.camera),
          )
        ],
      ),
    );
  }

  Future _urlContent() async {
    await showDialog(
        context: context,
        builder: (_) => urlDialog(controller: _urlController));
  }

  Future _handleMenuTapped(ImageSource source) async {
    var file = await ImagePicker.pickImage(source: source);
    Navigator.pop(
      context,
      _AddImageSheetResult(
        file: file,
      ),
    );
  }
}

class _AddImageSheetResult {
  final File file;

  _AddImageSheetResult({this.file});

  @override
  String toString() {
    return '$runtimeType(file: $file)';
  }
}
