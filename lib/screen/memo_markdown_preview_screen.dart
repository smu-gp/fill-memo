import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MemoMarkdownPreviewScreen extends StatefulWidget {
  final String content;
  final TextEditingController editingController;

  MemoMarkdownPreviewScreen({
    Key key,
    this.content,
    this.editingController,
  }) : super(key:key);

  @override
  _MemoMarkdownPreviewScreenState createState() => _MemoMarkdownPreviewScreenState();
}

class _MemoMarkdownPreviewScreenState extends State<MemoMarkdownPreviewScreen> {
  String _content;
  TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
    _editingController = widget.editingController;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingController.text),
      ),
      body: Markdown(
        data: _content,
        onTapLink: (href) => launch(href),
      )
    );
  }
}