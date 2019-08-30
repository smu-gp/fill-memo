import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/list_item.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MemoMarkdownScreen extends StatefulWidget {

  @override
  _MemoMarkdownScreenState createState() => _MemoMarkdownScreenState();
}

class _MemoMarkdownScreenState extends State<MemoMarkdownScreen> {
  TextEditingController _editingController = TextEditingController();
  String content = "";

  @override
  void initState() {
    super.initState();
    _editingController.addListener(() {
      setState(() {
        content = _editingController.value.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
            child: Markdown(
              data: content,

            ),
            flex: 1,
          ),
          Divider(),
          Expanded(
            child: TextField(
              controller: _editingController,
              enableInteractiveSelection: true,
              keyboardType: TextInputType.multiline,
              maxLength: null,
              textInputAction: TextInputAction.newline,
              textAlign: TextAlign.start,
              maxLengthEnforced: true,
              maxLines: 100,
              minLines: 10,
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
                      icon: Icon(Icons.image),
                      onPressed: () {
                        _showImageSettingBottomSheet();
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
                        icon: Icon(Icons.format_strikethrough),
                        onPressed: () {
                          _wrapContent('~~');
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

  Future _showPreviewScreen() async{
    await Navigator.push(
      context,
      Routes().markdownPreviewMemo(content: content),
    );
    setState(() {
    });
  }

  void _clear() {
    _editingController.clear();
  }

  Future _showImageSettingBottomSheet() async {
    await showModalBottomSheet(
        elevation: 1.0,
        context: context,
        builder: (context) => imageSettingBottomSheet(
          controller: _editingController,
        )
    );
  }

  void _linkContent() {
    var selection = _editingController.selection;
    var text = _editingController.value.text;
    String link = '[link](url)';

    String before = selection.textBefore(text);
    String inner = link;
    String after = '' + selection.textAfter(text);

    _editingController.value = _editingController.value.copyWith(
      text: before + inner + after,
      selection: TextSelection(baseOffset: selection.start + link.length - 4, extentOffset: selection.start + link.length - 1),
    );
  }

  void _wrapContent(String content) {
    var selection = _editingController.selection;
    var text = _editingController.value.text;

    String before = selection.textBefore(text);
    String inner = " ";
    if(content.contains('~') || content.contains('*') || content.contains('`'))
      inner = content + selection.textInside(text) + content;
    else
      inner = content + selection.textInside(text);
    String after = selection.textAfter(text);

    _editingController.value = _editingController.value.copyWith(
        text: before + inner + after,
        selection: TextSelection.collapsed(offset: selection.start + content.length)
        //selection: TextSelection(baseOffset: selection.start, extentOffset: selection.end + (content.length) * 2)
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

  void _prefixContent(String content) {
    var text = _editingController.value.text;
    var selection = _editingController.selection;

    int linestart = _findLineStart(selection.end, text);
    String before = selection.textBefore(text);
    String after = selection.textAfter(text);
    String bf = " ";
    print(text.length);
    print(linestart);

    if(text.substring(linestart, selection.end).startsWith(content)) {
      print(linestart);
      bf = before.substring(linestart, selection.start).replaceFirst(content, '');
      if(linestart == 0)
        before = bf;
      else {
        before = before.substring(0, linestart);
        before += bf;
      }
      _editingController.value = _editingController.value.copyWith(
          text: before + after,
          selection: TextSelection.collapsed(offset: before.length)
      );
    } else {
      if(linestart == 0)
        bf = content + before;
      else {
        String st = before.substring(0, linestart);
        String s = before.substring(linestart, selection.start);
        bf = st + content + s;
      }
      before = bf;
      _editingController.value = _editingController.value.copyWith(
          text: before + after,
          selection: TextSelection.collapsed(offset: selection.start + content.length)
      );
    }
  }
}

class urlDialog extends StatelessWidget {
  final TextEditingController controller;

  urlDialog({
    Key key,
    this.controller,
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Input URL'),
      content: TextField(
        enableInteractiveSelection: true,
        controller: controller,
        decoration: InputDecoration(
            hintText: 'url'
        ),
      ),
      actions: [
        FlatButton(
          child: Text('CANCEL'),
          onPressed: Navigator.of(context).pop,
        ),
        FlatButton(
          child: Text('SUBMIT'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class imageSettingBottomSheet extends StatefulWidget {
  final TextEditingController controller;
  
  imageSettingBottomSheet({
    Key key,
    this.controller,
  }) : super(key : key);

  @override
  _imageSettingBottomSheetState createState() => _imageSettingBottomSheetState();
}

class _imageSettingBottomSheetState extends State<imageSettingBottomSheet> {
  TextEditingController _urlController = TextEditingController();
  bool _enableTextRecognition = false;

  @override
  Widget build(BuildContext context) {
    return Container (
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
        builder: (_) => urlDialog(
            controller: _urlController
        )
    );
    print(_urlController.text);

    /*var selection = _editingController.selection;
    var text = _editingController.value.text;

    String url1 = '[link](';
    String url2 = ')';

    String before = selection.textBefore(text);
    String inner = url1 + url2;
    String after = '' + selection.textAfter(text);

    _editingController.value = _editingController.value.copyWith(
      text: before + inner + after,
      selection: TextSelection(baseOffset: selection.start + inner.length - 4, extentOffset: selection.start + inner.length - 1),
    );*/
  }

  Future _handleMenuTapped(ImageSource source) async {
    var file = await ImagePicker.pickImage(source: source);
    Navigator.pop(
      context,
      _AddImageSheetResult(
        file: file,
        enableTextRecognition: _enableTextRecognition,
      ),
    );
  }
}

class _AddImageSheetResult {
  final File file;
  final bool enableTextRecognition;

  _AddImageSheetResult({this.file, this.enableTextRecognition});

  @override
  String toString() {
    return '$runtimeType(file: $file, enableTextRecognition: $enableTextRecognition)';
  }
}