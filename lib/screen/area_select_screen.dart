import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_client/localization.dart';
import 'package:sp_client/screen/result_screen.dart';

class AreaSelectScreen extends StatefulWidget {
  final File selectImage;

  AreaSelectScreen({Key key, @required this.selectImage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AreaSelectScreenState();
}

class _AreaSelectScreenState extends State<AreaSelectScreen> {
  static const openCVChannel = const MethodChannel('spclient.smugp.com/opencv');

  String _openCVVersionString;

  @override
  void initState() {
    super.initState();
    _getOpenCVVersion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'OpenCV version',
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('OpenCV version'),
                        content: Text(_openCVVersionString),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('CLOSE'))
                        ],
                      ));
            },
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _showProgressDialog();
              _startTimer();
            },
            tooltip: AppLocalizations.of(context).get('send_image'),
          )
        ],
        elevation: 0.0,
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

  Future<void> _getOpenCVVersion() async {
    String versionString = await openCVChannel.invokeMethod("getVersionString");
    setState(() {
      _openCVVersionString = versionString;
    });
  }
}
