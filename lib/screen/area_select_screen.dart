import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/dependency_injection.dart';
import 'package:sp_client/localization.dart';
import 'package:sp_client/models.dart';
import 'package:sp_client/screen/result_screen.dart';

class AreaSelectScreen extends StatefulWidget {
  final File selectImage;

  AreaSelectScreen({Key key, @required this.selectImage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AreaSelectScreenState();
}

class _AreaSelectScreenState extends State<AreaSelectScreen> {
  static const openCVChannel = const MethodChannel('spclient.smugp.com/opencv');

  HistoryBloc _bloc;
  String _openCVVersionString;

  @override
  void initState() {
    super.initState();
    _getOpenCVVersion();
  }

  @override
  Widget build(BuildContext context) {
    var db = Injector.of(context).database;
    _bloc = HistoryBloc(db);
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
            onPressed: () async {
              _showProgressDialog();
              var newHistory = await _writeHistory();
              _navigationResult(newHistory.id);
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
                SizedBox(
                  width: 24.0,
                ),
                Text(AppLocalizations.of(context).get('dialog_send_image'))
              ],
            ),
          );
        });
  }

  Future<History> _writeHistory() {
    var newHistory = History();
    newHistory.sourceImage = widget.selectImage.path;
    newHistory.createdAt = DateTime.now().millisecondsSinceEpoch;
    return _bloc.create(newHistory);
  }

  void _navigationResult(int historyId) {
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
