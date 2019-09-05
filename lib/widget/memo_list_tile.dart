import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/constants.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/rich_text_field/rich_text_field.dart';

import 'loading_progress.dart';

class MemoListTile extends StatelessWidget {
  final Memo memo;
  final bool useUpdatedAt;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  MemoListTile({
    Key key,
    this.memo,
    this.useUpdatedAt = false,
    this.selected,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 72,
        maxHeight: 240,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _MemoIcon(type: memo.type, selected: selected),
                  SizedBox(width: 16),
                  _MemoContent(memo, useUpdatedAt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoIcon extends StatelessWidget {
  final String type;
  final bool selected;

  _MemoIcon({this.type, this.selected = false});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    var icon;
    var iconColor = theme.accentIconTheme.color;
    var color = theme.primaryColorDark;

    if (type == typeRichText) {
      icon = MdiIcons.noteText;
    } else if (type == typeHandWriting) {
      icon = MdiIcons.draw;
    } else if (type == typeMarkdown) {
      icon = MdiIcons.markdown;
    }

    if (selected) {
      icon = Icons.check;
      color = theme.accentColor;
    }

    return CircleAvatar(
      radius: 24,
      child: Icon(icon, color: iconColor),
      backgroundColor: color,
    );
  }
}

class _MemoContent extends StatelessWidget {
  final Memo memo;
  final bool useUpdatedAt;

  _MemoContent(this.memo, this.useUpdatedAt);

  @override
  Widget build(BuildContext context) {
    var content;
    var contentImages;
    if (memo.type == typeRichText) {
      var style = Theme.of(context).textTheme.body1;
      var list = SpannableList.fromJson(memo.contentStyle);

      content = RichText(
        text: list.toTextSpan(memo.content, defaultStyle: style),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      );

      if (memo.contentImages != null && memo.contentImages.isNotEmpty) {
        contentImages = _MemoContentImageList(memo.contentImages);
      }
    } else if (memo.type == typeHandWriting) {
      content = null;
    } else if (memo.type == typeMarkdown) {
      content = null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          memo.title ?? "(${AppLocalizations.of(context).labelNoTitle})",
          style: Theme.of(context).textTheme.body1.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        content,
        SizedBox(height: 8),
        if (contentImages != null) contentImages,
        Text(
          Util.formatDate(useUpdatedAt ? memo.updatedAt : memo.createdAt),
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 10.0),
        ),
      ],
    );
  }
}

class _MemoContentImageList extends StatelessWidget {
  final List<String> contentImages;

  _MemoContentImageList(this.contentImages);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 80,
          maxWidth: double.infinity,
        ),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>
              _MemoContentImage(contentImages[index]),
          separatorBuilder: (context, index) => SizedBox(width: 4),
          itemCount: math.min(contentImages.length, 3),
          shrinkWrap: true,
        ),
      ),
    );
  }
}

class _MemoContentImage extends StatelessWidget {
  final String url;

  _MemoContentImage(this.url);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => LoadingProgress(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
