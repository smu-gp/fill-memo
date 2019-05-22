import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:preference_helper/preference_helper.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/bloc/history/history_bloc.dart';
import 'package:sp_client/bloc/result/result_bloc.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/repository/local/image_repository.dart';
import 'package:sp_client/screen/result_screen.dart';
import 'package:sp_client/service/processing_service.dart';
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

  AddImageBloc _addImageBloc;
  PreferenceBloc _preferenceBloc;

  @override
  void initState() {
    super.initState();
    _preferenceBloc = BlocProvider.of<PreferenceBloc>(context);
    _addImageBloc = AddImageBloc(widget.selectImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 48.0,
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Center(child: _buildContent()),
      ),
      bottomNavigationBar: SizedBox(
        height: 56.0,
        child: BottomAppBar(
          child: _buildActions(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<AddImageEvent, AddImageState>(
      bloc: _addImageBloc,
      builder: (BuildContext context, AddImageState state) {
        if (state is ReadyImage) {
          if (state.clipRect != null) {
            return ClipRect(
              child: Image.file(File(state.imagePath)),
              clipper: ImageClipper(state.clipRect),
            );
          } else {
            return Image.file(File(state.imagePath));
          }
        } else if (state is CropImage) {
          return ImageCropper(
            key: _cropperKey,
            image: FileImage(File(state.imagePath)),
            overlayHandleRange: _preferenceBloc
                .getPreference(AppPreferences.keyOverlayHandleRange)
                .value,
          );
        }
      },
    );
  }

  Widget _buildActions() {
    return BlocBuilder<AddImageEvent, AddImageState>(
      bloc: _addImageBloc,
      builder: (BuildContext context, AddImageState state) {
        List<Widget> actions;
        if (state is ReadyImage) {
          actions = <Widget>[
            if (state.clipRect == null)
              IconButton(
                icon: Icon(Icons.crop),
                onPressed: () => _addImageBloc.dispatch(StartCrop()),
              ),
            if (state.clipRect != null)
              IconButton(
                icon: Icon(Icons.undo),
                onPressed: () => _addImageBloc.dispatch(UndoCrop()),
              ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: _handleSendPressed,
              tooltip: AppLocalizations.of(context).actionSendImage,
            ),
          ];
        } else {
          actions = <Widget>[
            IconButton(
              icon: Icon(OMIcons.save),
              onPressed: () {
                var cropRect = _cropperKey.currentState.getWidgetCropRect();
                _addImageBloc.dispatch(SaveCrop(cropRect));
              },
            ),
          ];
        }
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: actions,
        );
      },
    );
  }

  void _handleSendPressed() async {
    _showProgressDialog();

    var useLocalDummy = _preferenceBloc
        .getPreference<bool>(AppPreferences.keyUseLocalDummy)
        .value;

    var currentTime = DateTime.now().millisecondsSinceEpoch;

    var results;
    if (!useLocalDummy) {
      var serviceUrl = _preferenceBloc
          .getPreference<String>(AppPreferences.keyServiceHost)
          .value;
      try {
        results = await _sendImage(serviceUrl);
      } catch (e) {
        Navigator.pop(context); // Close progress dialog
        _showSendErrorDialog(e);
        return;
      }
    } else {
      results = [
        Result(type: "text", content: "Test content"),
      ];
    }

    var imagePath = await _copySourceImage(currentTime);
    var newHistory = await _writeHistory(currentTime, imagePath);

    if (results != null) {
      _writeResults(results, newHistory.id);
      _navigationResult(newHistory);
    } else {
      Navigator.pop(context); // Close progress dialog
      _showSendErrorDialog();
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
      },
    );
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
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _navigationResult(History newHistory) {
    Navigator.pop(context);
    if (Util.isTablet(context)) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              width: 512.0,
              child: ResultScreen(
                history: newHistory,
              ),
            ),
          );
        },
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
                history: newHistory,
              ),
        ),
      );
    }
  }

  Future<List<Result>> _sendImage(String serviceHost) async {
    var cropRect = await _getCropRect();
    return ProcessingService(
      httpClient: http.Client(),
      baseUrl: 'http://$serviceHost:8000',
    ).sendImage(
      imageFile: widget.selectImage,
      cropLeft: cropRect.left,
      cropTop: cropRect.top,
      cropRight: cropRect.right,
      cropBottom: cropRect.bottom,
    );
  }

  Future<Rect> _getCropRect() async {
    var clipRect = (_addImageBloc.currentState as ReadyImage).clipRect;
    if (clipRect != null) {
      return clipRect;
    } else {
      var imageInfo = await _getImageInfo(FileImage(widget.selectImage));
      return Rect.fromLTWH(
        0,
        0,
        imageInfo.image.width.toDouble(),
        imageInfo.image.height.toDouble(),
      );
    }
  }

  Future<ImageInfo> _getImageInfo(ImageProvider imageProvider) {
    Completer<ImageInfo> completer = Completer<ImageInfo>();
    imageProvider
        .resolve(createLocalImageConfiguration(context))
        .addListener((ImageInfo info, _) => completer.complete(info));
    return completer.future;
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
    return BlocProvider.of<HistoryBloc>(context).createHistory(newHistory);
  }

  void _writeResults(List<Result> results, int historyId) {
    BlocProvider.of<ResultBloc>(context).addResults(results, historyId);
  }
}

class ImageClipper extends CustomClipper<Rect> {
  final Rect clipRect;

  ImageClipper(this.clipRect);

  @override
  Rect getClip(Size size) {
    return clipRect;
  }

  @override
  bool shouldReclip(ImageClipper oldClipper) => oldClipper.clipRect != clipRect;
}
