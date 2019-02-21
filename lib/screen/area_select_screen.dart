import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/bloc/history_bloc_provider.dart';
import 'package:sp_client/bloc/result_bloc.dart';
import 'package:sp_client/bloc/result_bloc_provider.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/screen/result_screen.dart';
import 'package:sp_client/util/localization.dart';

class AreaSelectScreen extends StatefulWidget {
  final File selectImage;

  AreaSelectScreen({Key key, @required this.selectImage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AreaSelectScreenState();
}

class _AreaSelectScreenState extends State<AreaSelectScreen> {
  static const openCVChannel = const MethodChannel('spclient.smugp.com/opencv');

  HistoryBloc _historyBloc;
  ResultBloc _resultBloc;
  String _openCVVersionString;

  @override
  void initState() {
    super.initState();
    _getOpenCVVersion();
  }

  @override
  Widget build(BuildContext context) {
    _historyBloc = HistoryBlocProvider.of(context);
    _resultBloc = ResultBlocProvider.of(context);
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
              _writeDummyResults(newHistory.id);
              _navigationResult(newHistory.id);
            },
            tooltip: AppLocalizations.of(context).actionSendImage,
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
                Text(AppLocalizations.of(context).dialogSendImage)
              ],
            ),
          );
        });
  }

  Future<History> _writeHistory() {
    var newHistory = History(
      sourceImage: widget.selectImage.path,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    return _historyBloc.create(newHistory);
  }

  void _writeDummyResults(int historyId) {
    var newTextResult = Result(
      historyId: historyId,
      type: 'text',
      content: 'Test content',
    );
    _resultBloc.create(newTextResult);
    var newImageResult = Result(
      historyId: historyId,
      type: 'image',
      content:
          'https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png',
    );
    _resultBloc.create(newImageResult);
  }

  void _navigationResult(int historyId) {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(
                  historyId: historyId,
                )));
  }

  Future<void> _getOpenCVVersion() async {
    String versionString = await openCVChannel.invokeMethod("getVersionString");
    setState(() {
      _openCVVersionString = versionString;
    });
  }
}
