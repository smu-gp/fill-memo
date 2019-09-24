import 'package:fill_memo/service/services.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MemoMarkdownPreviewScreen extends StatefulWidget {
  final String title;
  final String content;

  MemoMarkdownPreviewScreen({
    Key key,
    this.title,
    this.content,
  }) : super(key: key);

  @override
  _MemoMarkdownPreviewScreenState createState() =>
      _MemoMarkdownPreviewScreenState();
}

class _MemoMarkdownPreviewScreenState extends State<MemoMarkdownPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    var title;
    if (widget.title != null && widget.title.isNotEmpty) {
      title = widget.title;
    } else {
      title = AppLocalizations.of(context).labelNoTitle;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0.0,
      ),
      body: Markdown(
        data: widget.content ?? "",
        onTapLink: (url) => launchUrl(url),
      ),
    );
  }
}
