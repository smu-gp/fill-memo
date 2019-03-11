import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sp_client/model/history.dart';

class HistoryImage extends StatelessWidget {
  final History history;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const HistoryImage({
    Key key,
    @required this.history,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'history_${history.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Image.file(
            File(history.sourceImage),
            fit: BoxFit.cover,
          ),
          onTap: onTap,
          onLongPress: onLongPress,
        ),
      ),
    );
  }
}
