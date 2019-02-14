import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/screen/result_screen.dart';

class HistoryItem extends StatelessWidget {
  final History history;

  HistoryItem(
    this.history, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Ink.image(
        image: FileImage(File(history.sourceImage)),
        fit: BoxFit.cover,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ResultScreen(historyId: history.id)));
          },
        ),
      ),
    );
  }
}
