import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sp_client/localizations.dart';
import 'package:sp_client/screen/result.dart';

class AreaSelectScreen extends StatefulWidget {
  final File selectImage;

  AreaSelectScreen({Key key, @required this.selectImage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AreaSelectScreenState();
}

class _AreaSelectScreenState extends State<AreaSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).get('title')),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _showProgressDialog();
              _startTimer();
            },
            tooltip: AppLocalizations.of(context).get('send_image'),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(child: Image.file(widget.selectImage)),
    );
  }

  void _showProgressDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                      AppLocalizations.of(context).get('dialog_send_image')),
                )
              ],
            ),
          );
        });
  }

  _startTimer() async {
    var _duration = new Duration(seconds: 3);
    return Timer(_duration, _navigationResult);
  }

  void _navigationResult() {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ResultScreen()));
  }
}
