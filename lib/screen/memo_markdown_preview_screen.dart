import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MemoMarkdownPreviewScreen extends StatefulWidget {
  final String content;

  MemoMarkdownPreviewScreen({
    Key key,
    this.content,
  }) : super(key:key);

  @override
  _MemoMarkdownPreviewScreenState createState() => _MemoMarkdownPreviewScreenState();
}

class _MemoMarkdownPreviewScreenState extends State<MemoMarkdownPreviewScreen> {
  String _content;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('markdownPreview'),
      ),
      body: Markdown(
        data: _content,
      )
    );
  }
}