import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:preference_helper/preference_helper.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/bloc/history/history_bloc.dart';
import 'package:sp_client/bloc/result/result_bloc.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/repository/local/image_repository.dart';
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
        title: Text(AppLocalizations.of(context).titleAddImage),
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
    var useLocalDummy = _preferenceBloc
        .getTypePreference<bool>(
          key: AppPreferences.keyUseLocalDummy,
          initValue: false,
        )
        .value;

    if (useLocalDummy) {
      var currentTime = DateTime.now().millisecondsSinceEpoch;
      var imagePath = await _copySourceImage(currentTime);
      var newHistory = await _writeHistory(currentTime, imagePath);
      var dummyResults = [
        Result(type: "text", content: "Test content"),
      ];
      _writeResults(dummyResults, newHistory.id);
      _navigationResult(newHistory);
    } else {
      var serviceUrl = _preferenceBloc
          .getTypePreference<String>(
            key: AppPreferences.keyServiceUrl,
            initValue: AppPreferences.initServiceUrl,
          )
          .value;

      try {
        var results = await _sendImage(serviceUrl);
        if (results != null) {
          var currentTime = DateTime.now().millisecondsSinceEpoch;
          var imagePath = await _copySourceImage(currentTime);
          var newHistory = await _writeHistory(currentTime, imagePath);
          _writeResults(results, newHistory.id);
          _navigationResult(newHistory);
        } else {
          Navigator.pop(context);
          _showSendErrorDialog();
        }
      } catch (e) {
        Navigator.pop(context);
        _showSendErrorDialog(e);
      }
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

  void _navigationResult(History newHistory) {
    Navigator.pop(context);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(
                  history: newHistory,
                )));
  }

  Future<List<Result>> _sendImage(String serviceUrl) async {
    var cropRect = await _cropperKey.currentState.getActualCropRect();
    return ProcessingService(
      httpClient: http.Client(),
      baseUrl: serviceUrl,
    ).sendImage(
      imageFile: widget.selectImage,
      cropLeft: cropRect.left,
      cropTop: cropRect.top,
      cropRight: cropRect.right,
      cropBottom: cropRect.bottom,
    );
  }

  Future<String> _copySourceImage(int currentTime) async {
    var appDocDir = await getApplicationDocumentsDirectory();
    return LocalImageRepository(
      imageDirectory: appDocDir,
    ).addImage(currentTime, widget.selectImage);
  }

  Future<History> _writeHistory(int currentTime, String copiedImagePath) {
    var newHistory = History(
      sourceImage: copiedImagePath,
      createdAt: currentTime,
      folderId: 0,
    );
    return _historyBloc.createHistory(newHistory);
  }

  void _writeResults(List<Result> results, int historyId) {
    _resultBloc.addResults(results, historyId);
  }
}
