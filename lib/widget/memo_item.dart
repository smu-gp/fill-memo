import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/constants.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/painter.dart';
import 'package:sp_client/widget/rich_text_field/util/spannable_list.dart';

class MemoItem extends StatelessWidget {
  final Memo memo;
  final int date;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final bool selected;

  MemoItem(
    this.memo, {
    Key key,
    this.date,
    this.onTap,
    this.onLongPress,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (memo.type == typeRichText) {
      if(memo.contentImages.isNotEmpty){
        var style = Theme.of(context).textTheme.body1;
        var list = SpannableList.fromJson(memo.contentStyle);

        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              child: ClipRRect(
                child:Image.network(memo.contentImages.first),
                borderRadius:BorderRadius.circular(5.0),
              ),
            ),
            new RichText(
              text: list.toTextSpan(memo.content, defaultStyle: style),
              maxLines: 7,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      }
      else{
        var style = Theme.of(context).textTheme.body1;
        var list = SpannableList.fromJson(memo.contentStyle);

        content = RichText(
          text: list.toTextSpan(memo.content, defaultStyle: style),
          maxLines: 7,
          overflow: TextOverflow.ellipsis,
        );
      }
    }
    else if(memo.type == typeHandWriting){//&& memo?.content != null
      String imgPosLod = memo.content;
      List<String> devide = imgPosLod.split("ㄱ");
      Uint8List image= Uint8List.fromList(devide[0].codeUnits);
      content = new Container(
        child: ClipRRect(
          child: Image.memory(image),
           borderRadius:BorderRadius.circular(5.0),
        ),
      );
    }
    else if(memo.type == typeMarkdown){
      content = Container(
        child: MarkdownBody(
          data: memo.content,
        ),
      );
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
        child: Stack(
          children: [
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
                    Util.formatDate(date ?? memo.createdAt),
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
