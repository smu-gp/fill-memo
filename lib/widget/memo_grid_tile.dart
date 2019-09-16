import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/loading_progress.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:rich_text_editor/rich_text_editor.dart';

class MemoGridTile extends StatelessWidget {
  final Memo memo;
  final bool useUpdatedAt;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  MemoGridTile({
    Key key,
    this.memo,
    this.useUpdatedAt = false,
    this.onTap,
    this.onLongPress,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;
    Widget contentImage;
    if (memo.type == typeRichText) {
      var style = Theme.of(context).textTheme.body1;
      var list = SpannableList.fromJson(memo.contentStyle);

      content = RichText(
        text: list.toTextSpan(memo.content, defaultStyle: style),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      );

      if (memo.contentImages != null && memo.contentImages.isNotEmpty) {
        contentImage = ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: "image_${memo.id}_0",
              child: Material(
                child: CachedNetworkImage(
                  imageUrl: memo.contentImages.first,
                  fit: BoxFit.fill,
                  placeholder: (context, _) => LoadingProgress(),
                  errorWidget: (context, url, _) => Icon(Icons.error),
                ),
              ),
            ),
          ),
        );
      }
    } else if (memo.type == typeHandWriting) {
      String imgPosLod = memo.content;
      List<String> devide = imgPosLod.split("ㄱ");
      Uint8List image = Uint8List.fromList(devide[0].codeUnits);
      content = new Container(
        child: ClipRRect(
          child: Image.memory(image),
          borderRadius: BorderRadius.circular(5.0),
        ),
      );
    } else if (memo.type == typeMarkdown) {
      content = Container(
          child: MarkdownBody(
        data: memo.content,
      ));
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: selected
            ? BorderSide(
                color: Theme.of(context).accentColor,
                width: 2.0,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (contentImage != null) contentImage,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (memo.title != null)
                    Hero(
                      tag: "memoTitle_${memo.id}",
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          memo.title ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (memo.title != null) SizedBox(height: 4.0),
                  content,
                  SizedBox(height: 8.0),
                  Text(
                    Util.formatDate(
                        useUpdatedAt ? memo.updatedAt : memo.createdAt),
                    style: Theme.of(context)
                        .textTheme
                        .caption
                        .copyWith(fontSize: 10.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
