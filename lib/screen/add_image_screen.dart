import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:preference_helper/preference_helper.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/bloc/history/history_bloc.dart';
import 'package:sp_client/bloc/result/result_bloc.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/repository/remote/processing_service.dart';
import 'package:sp_client/screen/result_screen.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/image_cropper.dart';

class AddImageScreen extends StatefulWidget {
  final File selectImage;

  AddImageScreen({Key key, @required this.selectImage}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  final _cropperKey = GlobalKey<ImageCropperState>();

  HistoryBloc _historyBloc;
  ResultBloc _resultBloc;
  PreferenceBloc _preferenceBloc;

  @override
  void initState() {
    _historyBloc = BlocProvider.of<HistoryBloc>(context);
    _resultBloc = BlocProvider.of<ResultBloc>(context);
    _preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _handleSendPressed,
            tooltip: AppLocalizations.of(context).actionSendImage,
          )
        ],
        elevation: 0.0,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ImageCropper(
            key: _cropperKey,
            overlayHandleRange: _preferenceBloc
                .getTypePreference<bool>(
                  key: AppPreferences.keyOverlayHandleRange,
                  initValue: false,
                )
                .value,
            image: FileImage(widget.selectImage),
          ),
        ),
      ),
    );
  }

  void _handleSendPressed() async {
    _showProgressDialog();
    var prefUseLocalDummy = _preferenceBloc.getTypePreference<bool>(
        key: AppPreferences.keyUseLocalDummy, initValue: false);
    if (!prefUseLocalDummy.value) {
      try {
        var results = await _sendImage();
        if (results != null) {
          var history = await _writeHistory();
          _resultBloc.addResults(results, history.id);
          _navigationResult(history);
        } else {
          Navigator.pop(context);
          _showSendErrorDialog();
        }
      } catch (e) {
        Navigator.pop(context);
        _showSendErrorDialog(e);
      }
    } else {
      var history = await _writeHistory();
      var results = [
        Result(type: "text", content: "Test content"),
      ];
      _resultBloc.addResults(results, history.id);
      _navigationResult(history);
    }
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

  void _showSendErrorDialog([Exception e]) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error occurred'),
            content: Text(e != null ? e.toString() : 'No results from service'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  Future<List<Result>> _sendImage() async {
    var cropRect = await _cropperKey.currentState.getActualCropRect();
    var prefServiceUrl =
        BlocProvider.of<PreferenceBloc>(context).getTypePreference<String>(
      key: AppPreferences.keyServiceUrl,
      initValue: AppPreferences.initServiceUrl,
    );
    return ProcessingService(
      httpClient: http.Client(),
      baseUrl: prefServiceUrl.value,
    ).sendImage(
      imageFile: widget.selectImage,
      cropLeft: cropRect.left,
      cropTop: cropRect.top,
      cropRight: cropRect.right,
      cropBottom: cropRect.bottom,
    );
  }

  Future<History> _writeHistory() {
    var newHistory = History(
      sourceImage: widget.selectImage.path,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      folderId: 0,
    );
    return _historyBloc.createHistory(newHistory);
  }

  void _navigationResult(History newHistory) {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(
                  history: newHistory,
                )));
  }
}
