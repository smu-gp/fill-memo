import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';

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
                          memo.title,
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  if (memo.title != null) SizedBox(height: 4.0),
                  Text(_clipContent(memo.content, 7)),
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

  String _clipContent(String content, int limit) {
    if (content == null) return "";

    var lines = content.split("\n");
    if (lines.length < limit)
      return content;
    else {
      var clipLines = lines.sublist(0, limit - 1);
      var clipContent = "";
      clipLines.forEach((line) => clipContent += "$line\n");
      clipContent += "…";
      return clipContent;
    }
  }
}
