import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/list_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:rich_text_editor/rich_text_editor.dart';
import 'package:sp_client/service/services.dart' as Service;
import 'package:sp_client/util/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import 'dart:io';

class MemoMarkdownScreen extends StatefulWidget {
  final Memo memo;

  MemoMarkdownScreen(
      this.memo, {
        Key key,
  }) : super(key : key);

  @override
  _MemoMarkdownScreenState createState() => _MemoMarkdownScreenState();
}

class _MemoMarkdownScreenState extends State<MemoMarkdownScreen> {
  SpannableTextEditingController _editingContentController;
  TextEditingController _editingTitleController;
  String content = "";
  double _progressValue = 0;
  MemoBloc _memoBloc;

  PreferenceRepository _preferenceRepository;
  List<String> _memoContentImages;

  @override
  void initState() {
    super.initState();
    _editingContentController = SpannableTextEditingController(text: widget.memo.content ?? " ");
    _editingTitleController = TextEditingController(text: widget.memo.title ?? "");
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingTitleController.text),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              _undo();
            },
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: () {
              _redo();
            },
          ),
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
          /*Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.only(left: 16.0),
            child: _TitleEditText(controller: _editingTitleController),
          ),*/
          Expanded(
            child: Markdown(
              data: _editingContentController.text,
              /*styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                    a: Theme.of(context).textTheme.body1.
                    copyWith(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.bold),
                    blockquote: Theme.of(context).textTheme.body1.
                    copyWith(backgroundColor: Colors.transparent, fontSize: 22.0, color: Colors.black, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),*/
              onTapLink: (href) => launch(href),
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
                  border: InputBorder.none,
                  hintText: 'input text'
              ),
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
                        }
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        _moveCursor(true);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        _moveCursor(false);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_sweep),
                      onPressed: () {
                        _lineDelete();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.image),
                      onPressed: () {
                        _insertImageDialog();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.keyboard),
                      onPressed: () {
                        //_showHelpKeyDialog();
                      },
                    ),
                    IconButton(
                        icon: Icon(Icons.looks_one),
                        onPressed: () {
                          _prefixContent('# ');
                        }
                    ),
                    IconButton(
                        icon: Icon(Icons.looks_two),
                        onPressed: () {
                          _prefixContent('## ');
                        }
                    ),
                    IconButton(
                        icon: Icon(Icons.looks_3),
                        onPressed: () {
                          _prefixContent('### ');
                        }
                    ),
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
                    ),
                    IconButton(
                        icon: Icon(Icons.linear_scale),
                        onPressed: () {
                          _prefixContent('***');
                        }
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _moveCursor(bool direction) {
    var text = _editingContentController.value.text;
    var selection = _editingContentController.selection;

    if(direction) {
      if(selection.start == 0)
        return;
      else {
        _editingContentController.value = _editingContentController.value.copyWith(
            selection: TextSelection.collapsed(offset: selection.start - 1)
        );
      }
    } else {
      if(selection.start == text.length)
        return;
      else {
        _editingContentController.value = _editingContentController.value.copyWith(
            selection: TextSelection.collapsed(offset: selection.start + 1)
        );
      }
    }
  }

  void _lineDelete() {
    var text = _editingContentController.value.text;
    var selection = _editingContentController.selection;

    int lineStart = _findLineStart(selection.end, text);
    int lineEnd = _findLineEnd(selection.end, text);

    String before = selection.textBefore(text).substring(0, lineStart);
    String after = text.substring(lineEnd, text.length);

    _editingContentController.value = _editingContentController.value.copyWith(
        text: before + after,
        selection: TextSelection.collapsed(offset: lineStart)
    );
  }

  void _undo() {
    if(_editingContentController.canUndo()) {
      _editingContentController.undo();
    }
  }

  void _redo() {
    if(_editingContentController.canRedo())
      _editingContentController.redo();
  }

  void _insertImageDialog() async{
    var selection = _editingContentController.selection;
    var text = _editingContentController.text;
    TextEditingController controller = TextEditingController();
    _UrlResult result = await showDialog(
        context: context,
        builder: (_) => urlDialog(
          controller: controller,
          preferenceRepository: _preferenceRepository,
        )
    );
    if(result.url != "") {
      if(result.accessServer) {
        String before = selection.textBefore(text);
        String inner = result.url;
        String after = selection.textAfter(text);
        _editingContentController.value = _editingContentController.value.copyWith(
          text: before + inner + after,
          selection: selection,
        );
      } else {
        String before = selection.textBefore(text);
        String inner = '![link]('+ result.url +')';
        String after = '' + selection.textAfter(text);
        _editingContentController.value = _editingContentController.value.copyWith(
          text: before + inner + after,
          selection: selection,
        );
      }
    } else {
      _editingContentController.value = _editingContentController.value.copyWith(
        text: text,
        selection: selection,
      );
    }
  }

  Future _showPreviewScreen() async{
    await Navigator.push(
      context,
      Routes().markdownPreviewMemo(
          content: content,
          editingController: _editingTitleController,
      ),
    );
    setState(() {
    });
  }

  void _clear() {
    _editingContentController.clear();
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
      selection: TextSelection(baseOffset: selection.start + link.length - 4, extentOffset: selection.start + link.length - 1),
    );
  }

  void _wrapContent(String content) {
    var selection = _editingContentController.selection;
    var text = _editingContentController.value.text;

    String before = selection.textBefore(text);
    String inner = " ";
    if(content.contains('~') || content.contains('*') || content.contains('`'))
      inner = content + selection.textInside(text) + content;
    else
      inner = content + selection.textInside(text);
    String after = selection.textAfter(text);

    _editingContentController.value = _editingContentController.value.copyWith(
        text: before + inner + after,
        selection: TextSelection.collapsed(offset: selection.start + content.length)
    );
  }

  int _findLineStart(int cursor, String text) {
    int i = cursor - 1;
    for(;i >= 0; i--) {
      if(text[i] == '\n')
        break;
    }
    return i + 1;
  }

  int _findLineEnd(int cursor, String text) {
    int i = _findLineStart(cursor, text);
    while(true) {
      if(i == text.length)
        break;
      if(text[i] == '\n')
        break;
      i++;
    }
    return i;
  }

  void _prefixContent(String content) {
    var text = _editingContentController.value.text;
    var selection = _editingContentController.selection;

    int lineStart = _findLineStart(selection.start, text);
    String before = selection.textBefore(text);
    String inner = selection.textInside(text);
    String after = selection.textAfter(text);
    String bf = " ";
    if(text.substring(lineStart, selection.end).startsWith(content)) {
      bf = before.substring(lineStart, selection.start).replaceFirst(content, '');
      if(lineStart == 0)
        before = bf;
      else {
        before = before.substring(0, lineStart);
        before += bf;
      }
      _editingContentController.value = _editingContentController.value.copyWith(
          text: before + inner + after,
          selection: TextSelection.collapsed(offset: before.length)
      );
    } else {
      if(lineStart == 0)
        bf = content + before;
      else {
        String st = before.substring(0, lineStart);
        String s = before.substring(lineStart, selection.start);
        bf = st + content + s;
      }
      before = bf;
      _editingContentController.value = _editingContentController.value.copyWith(
          text: before + inner + after,
          selection: TextSelection.collapsed(offset: selection.start + content.length)
      );
    }


  }

  void _updateMarkdownMemo() {
    var memo = widget.memo;
    var titleText = _editingTitleController.text;
    var contentText = content;

    var isChanged = memo.title != titleText ||
        memo.content != contentText;


    memo.title = titleText.isNotEmpty ? titleText : null;
    memo.content = contentText.isNotEmpty ? contentText : null;
    memo.contentImages = _memoContentImages;

    if (isChanged) {
      memo.updatedAt = DateTime.now().millisecondsSinceEpoch;
    }

    var isValid = memo.title != null || memo.content != null;

    if(widget.memo.id != null) {
      if(isValid){
        if(isChanged) {
          _memoBloc.dispatch(UpdateMemo(memo));
        }
      } else {
        _memoBloc.dispatch(DeleteMemo(memo));
      }
    } else {
      if(isValid) {
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
  bool _enableTextRecognition = false;
  bool _accessFirebase;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _preferenceRepository = widget.preferenceRepository;
    _accessFirebase = false;
  }

  @override
  Widget build(BuildContext context) {
     return AlertDialog(
      contentPadding: EdgeInsets.only(left: 1.0, right: 1.0),
      title: Text('Input URL'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
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
          TextField(
            enableInteractiveSelection: true,
            controller: _controller,
            decoration: InputDecoration(
                hintText: 'url'
            ),
          ),
          ListItem(
            leading: Icon(
              Icons.folder,
              color: Colors.deepOrangeAccent,
            ),
            title: AppLocalizations.of(context).imageFromGallery,
              onTap: () async{
                var file = await _handleMenuTapped(ImageSource.gallery);
                if(file != null) {
                  if(_enableTextRecognition) {
                    var result = await _uploadProcessingServer(file);
                    Navigator.pop(context, _UrlResult(
                      url: result,
                      accessServer: true,
                    ));
                  } else {
                    var imageUrl = await _uploadFirebaseStorage(file);
                    _accessFirebase = true;
                    _controller.text = imageUrl;
                  }
                } else {
                  Navigator.pop(context);
                  _showSendErrorDialog();
                }
              }
          ),
          ListItem(
            leading: Icon(
              Icons.photo_camera,
              color: Colors.deepOrangeAccent,
            ),
            title: AppLocalizations.of(context).imageFromCamera,
              onTap: () async{
                var file = await _handleMenuTapped(ImageSource.camera);
                if(file != null) {
                  if(_enableTextRecognition) {
                    var result = await _uploadProcessingServer(file);
                    Navigator.pop(context, _UrlResult(
                      url: result,
                      accessServer: true,
                    ));
                  } else {
                    var imageUrl = await _uploadFirebaseStorage(file);
                    _accessFirebase = true;
                    _controller.text = imageUrl;
                  }
                } else {
                  Navigator.pop(context);
                  _showSendErrorDialog();
                }
              }
          )
        ],
      ),
      actions: [
        FlatButton(
          child: Text(AppLocalizations.of(context).androidCancelButton),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).androidConfirmButton),
          onPressed: () async{
            if(_controller.text.isNotEmpty &&
                (_controller.text.startsWith('http://') || _controller.text.startsWith('https://'))) {
              if(!_accessFirebase) {
                String url = _controller.text;
                var file = await _downloadFile(url, url.split('/')[2]);
                if(file != null) {
                  if(_enableTextRecognition) { // access server
                    _controller.text = await _uploadProcessingServer(file);
                    Navigator.pop(context, _UrlResult(
                      url: _controller.text,
                      accessServer: true,
                    ));
                  } else { // not access firebase
                    _controller.text = await _uploadFirebaseStorage(file);
                    Navigator.pop(context, _UrlResult(
                      url: _controller.text,
                      accessServer: false,
                    ));
                  }
                } else {
                  Navigator.pop(context);
                  _showSendErrorDialog();
                }
              } else { // already access firebase
                Navigator.pop(context, _UrlResult(
                  url: _controller.text,
                  accessServer: false,
                ));
              }
            } else { // not https or http
              Navigator.pop(context);
              _showSendErrorDialog();
            }
          },
        ),
      ],
    );
  }

  static var httpClient = new HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future _handleMenuTapped(ImageSource source) async {
    var file = await ImagePicker.pickImage(source: source);
    return file;
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

  void _showSendErrorDialog([Object e]) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error occurred'),
          content: Text(e != null ? e.toString() : 'No results from service'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).androidConfirmButton),
            ),
          ],
        );
      },
    );
  }

  Future _uploadProcessingServer(File imageFile) async {
    _showProgressDialog();

    try {
      var host =
          _preferenceRepository.getString(AppPreferences.keyServiceHost) ??
              defaultServiceHost;

      var results = await Service.sendImage(
        imageFile: imageFile,
        baseUrl: processingServiceUrl(host),
      );

      Navigator.pop(context); // Hide progress dialog
      var str =  showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).titleResult),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 8.0,
              ),
              content: Container(
                width: 300,
                height: 400,
                child: Scrollbar(
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: results
                          .map((result) => ListItem(
                        /*leading: Checkbox(
                            value: result.isChecked,
                            onChanged: (bool value) {
                              setState(() {
                                result.isChecked = value;
                              });
                            }
                        ),*/
                        title: result.content.split(" ")[0],
                        onTap: () {
                          Navigator.pop(context, result.content);
                        },
                        /*trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              iconSize: 15.0,
                              icon: Icon(Icons.format_bold,),
                              onPressed: () {
                                setState(() {

                                });
                              },
                            ),
                            IconButton(
                              iconSize: 15.0,
                              icon: Icon(Icons.format_italic,),
                              onPressed: () {
                                setState(() {
                                });
                              },
                            )
                          ],
                        )*/
                      )).toList(),
                      /*children: results
                          .map((result) => ListItem(

                        title: result.content,
                        onTap: () {},
                      ))
                          .toList(),*/
                    ),
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).androidCancelButton),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return str;
    } catch (e) {
      Navigator.pop(context); // Hide progress dialog
      _showSendErrorDialog(e);
    }
  }

  Future _uploadFirebaseStorage(File imageFile) async {
    _showProgressDialog();

    final userId = _preferenceRepository.getString(AppPreferences.keyUserId);
    final uuid = Uuid().v1();
    final ext = imageFile.path.split(".")[1];
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child(userId).child('$uuid.$ext');
    final uploadTask = storageRef.putFile(imageFile);

    await for (final event in uploadTask.events) {
      if (event.type == StorageTaskEventType.progress) {
        if(mounted) {
          setState(() {
            _progressValue =
                event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
            debugPrint(_progressValue.toString());
          });
        }
      } else if (event.type == StorageTaskEventType.success) {
        final downloadURL = await event.snapshot.ref.getDownloadURL();
        Navigator.pop(context);
        return downloadURL;
      }
    }
    //Navigator.pop(context);
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

class _UrlResult {
  final String url;
  final bool accessServer;

  _UrlResult({this.url, this.accessServer});

  @override
  String toString() {
    return '$runtimeType(url: $url, accessServer: $accessServer)';
  }
}