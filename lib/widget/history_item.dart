import 'package:flutter/material.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/screen/result_screen.dart';
import 'package:sp_client/widget/history_image.dart';

class HistoryItem extends StatelessWidget {
  final History history;

  HistoryItem(
    this.history, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HistoryImage(
      history: history,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultScreen(history: history)));
      },
    );
  }
}
