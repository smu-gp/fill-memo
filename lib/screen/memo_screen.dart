import 'dart:io';

import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/screen/process_result_screen.dart';
import 'package:fill_memo/service/services.dart' as Service;
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/dimensions.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/list_item.dart';
import 'package:fill_memo/widget/loading_progress.dart';
import 'package:fill_memo/widget/network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:rich_text_editor/rich_text_editor.dart';
import 'package:uuid/uuid.dart';

typedef ImageListCallback = void Function(int);

class MemoScreen extends StatefulWidget {
  final Memo memo;

  MemoScreen(
    this.memo, {
    Key key,
  }) : super(key: key);

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  TextEditingController _editTitleTextController;
  SpannableTextEditingController _editContentTextController;

  MemoBloc _memoBloc;
  PreferenceRepository _preferenceRepository;

  List<String> _memoContentImages;
  bool _showProgress = false;
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();
    _memoBloc = BlocProvider.of<MemoBloc>(context);
    _preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);

    _editTitleTextController =
        TextEditingController(text: widget.memo.title ?? "");

    var styleList;
    if (widget.memo.contentStyle != null) {
      styleList = SpannableList.fromJson(widget.memo.contentStyle);
    }

    _editContentTextController = SpannableTextEditingController(
      text: widget.memo.content ?? "",
      styleList: styleList,
      historyLength: 10,
    );

    _memoContentImages = []..addAll(widget.memo.contentImages ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: _showProgress,
            child: SizedBox(
              child: LinearProgressIndicator(
                backgroundColor: AppColors.accentColor.withOpacity(0.2),
                value: _progressValue,
              ),
              height: 4,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: Dimensions.contentWidth(context),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        visible: _memoContentImages.isNotEmpty,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                Dimensions.imageHorizontalMargin(context),
                          ),
                          child: _ContentImageList(
                            imageList: _memoContentImages,
                            heroTagId: widget.memo.id,
                            onItemTap: _handleImageItemTapped,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.keyline,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: kToolbarHeight,
                              child: _TitleEditText(
                                  controller: _editTitleTextController),
                            ),
                            _ContentEditText(
                              autofocus: widget.memo.id == null,
                              controller: _editContentTextController,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Material(
            elevation: 8.0,
            child: Container(
              height: 48.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(OMIcons.image),
                      onPressed: _showAddImageSheet,
                    ),
                    VerticalDivider(),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: StyleToolbar(
                          controller: _editContentTextController,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _updateMemo();
    _editTitleTextController.dispose();
    _editContentTextController.dispose();
    super.dispose();
  }

  void _handleImageItemTapped(int index) async {
    await Navigator.push(
      context,
      Routes().memoImage(
        contentImages: _memoContentImages,
        initIndex: index,
        heroTagId: widget.memo.id,
      ),
    );
    setState(() {});
  }

  void _updateMemo() {
    var titleText = _editTitleTextController.text;
    var contentText = _editContentTextController.text;
    var contentStyleText = _editContentTextController.styleList.toJson();

    var memo = widget.memo;
    var isChanged = memo.title != titleText ||
        memo.content != contentText ||
        memo.contentStyle != contentStyleText ||
        memo.contentImages != _memoContentImages;

    memo.title = titleText.isNotEmpty ? titleText : null;
    memo.content = contentText.isNotEmpty ? contentText : null;
    memo.contentStyle = contentStyleText.isNotEmpty ? contentStyleText : null;
    memo.contentImages = _memoContentImages;

    if (isChanged) {
      memo.updatedAt = DateTime.now().millisecondsSinceEpoch;
    }

    var isValid = memo.title != null || memo.content != null;

    if (widget.memo.id != null) {
      if (isValid) {
        if (isChanged) {
          _memoBloc.dispatch(UpdateMemo(memo));
        }
      } else {
        _memoBloc.dispatch(DeleteMemo(widget.memo));
      }
    } else {
      if (isValid) {
        _memoBloc.dispatch(AddMemo(memo));
      }
    }
  }

  Future _addImage(
    File file,
    bool enableTextRecognition,
    TextSelection selection,
  ) async {
    if (enableTextRecognition) {
      try {
        var results = await _uploadProcessServer(file);
        if (results != null && results.isNotEmpty) {
          await _showProcessResults(results, selection);
        } else {
          await _showProcessNoResults();
        }
      } catch (e) {
        Navigator.pop(context); // Hide progress dialog
        await _showProcessErrorDialog(e);
      }
    } else {
      await _uploadFirebaseStorage(file);
    }
  }

  Future<List<ProcessResult>> _uploadProcessServer(
    File imageFile,
  ) async {
    _showProgressDialog();

    var host = _preferenceRepository.getString(AppPreferences.keyServiceHost) ??
        defaultServiceHost;

    var results = await Service.sendImage(
      imagePath: imageFile.path,
      baseUrl: processingServiceUrl(host),
    );

    Navigator.pop(context); // Hide progress dialog
    return results;
  }

  Future _uploadFirebaseStorage(File imageFile) async {
    final userId = _preferenceRepository.getString(AppPreferences.keyUserId);
    final uuid = Uuid().v1();
    final ext = imageFile.path.split(".")[1];
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child(userId).child('$uuid.$ext');
    final uploadTask = storageRef.putFile(imageFile);

    setState(() {
      _showProgress = true;
    });

    await for (final event in uploadTask.events) {
      if (event.type == StorageTaskEventType.progress) {
        setState(() {
          _progressValue =
              event.snapshot.bytesTransferred / event.snapshot.totalByteCount;
          debugPrint(_progressValue.toString());
        });
      } else if (event.type == StorageTaskEventType.success) {
        final downloadURL = await event.snapshot.ref.getDownloadURL();

        _memoContentImages.add(downloadURL);

        setState(() {
          _progressValue = 0;
          _showProgress = false;
        });
      }
    }
  }

  Future _showAddImageSheet() async {
    TextSelection currentSelection = _editContentTextController.selection;
    _AddImageResult result = await showModalBottomSheet(
      context: context,
      builder: (context) => _AddImageSheet(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
    );
    if (result != null && result.file != null) {
      _addImage(result.file, result.enableTextRecognition, currentSelection);
    }
  }

  Future _showProgressDialog() async {
    await showDialog(
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

  Future _showProcessErrorDialog(Object e) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).labelErrorOccurred),
          content: Text(e.toString()),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context).labelClose),
            ),
          ],
        );
      },
    );
  }

  Future _showProcessResults(
    List<ProcessResult> results,
    TextSelection selection,
  ) async {
    var selectedItems;
    if (Util.isLarge(context)) {
      selectedItems = await showDialog(
        context: context,
        builder: (context) => ProcessResultScreen(results),
      );
    } else {
      selectedItems = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProcessResultScreen(results)),
      );
    }

    if (selectedItems != null) {
      var processedText = "";
      selectedItems.forEach((result) {
        processedText += (result as ProcessResult).content;
      });

      var text = _editContentTextController.text;
      if (selection.isNormalized && selection.isValid) {
        text = selection.textBefore(text) +
            selection.textInside(text) +
            processedText +
            selection.textAfter(text);
      } else {
        text = text += processedText;
      }
      _editContentTextController.text = text;
    }
  }

  Future _showProcessNoResults() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).titleResult),
          content: Text(AppLocalizations.of(context).labelNoProcessResult),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).labelClose),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
}

class _TitleEditText extends StatelessWidget {
  final TextEditingController controller;

  _TitleEditText({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: TextField(
        autofocus: false,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          hintText: AppLocalizations.of(context).hintInputTitle,
        ),
        style: Theme.of(context).textTheme.headline,
        maxLines: 1,
        onChanged: (value) {},
      ),
    );
  }
}

class _ContentEditText extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;

  _ContentEditText({
    Key key,
    this.autofocus = false,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: Scrollbar(
        child: TextField(
          autofocus: autofocus,
          controller: controller,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            hintText: AppLocalizations.of(context).hintInputNote,
          ),
        ),
      ),
    );
  }
}

class _ContentImageList extends StatelessWidget {
  final List<String> imageList;
  final String heroTagId;
  final ImageListCallback onItemTap;

  _ContentImageList({
    Key key,
    this.imageList = const [],
    this.heroTagId,
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var child;
    if (imageList.length > 1) {
      child = _buildList();
    } else {
      child = _buildItem(imageList[0], 0);
    }

    return Container(
      width: double.infinity,
      height: Dimensions.imageHeight(context),
      child: child,
    );
  }

  Widget _buildList() {
    return ListView(
      scrollDirection: Axis.horizontal,
      itemExtent: Dimensions.imageNormalWidth,
      children: imageList
          .asMap()
          .entries
          .map((entry) => Padding(
                padding: EdgeInsets.only(
                  right: (entry.key != imageList.length - 1) ? 4.0 : 0,
                ),
                child: _buildItem(entry.value, entry.key),
              ))
          .toList(),
    );
  }

  Widget _buildItem(String url, int index) {
    return Hero(
      tag: "image_${heroTagId}_$index",
      child: Material(
        child: _ContentImageItem(
          url: url,
          onTap: () => onItemTap(index),
        ),
      ),
    );
  }
}

class _ContentImageItem extends StatelessWidget {
  final String url;
  final VoidCallback onTap;

  _ContentImageItem({Key key, this.url, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: PlatformNetworkImage(
        url: url,
        fit: BoxFit.cover,
        placeholder: LoadingProgress(),
      ),
    );
  }
}

class _AddImageSheet extends StatefulWidget {
  @override
  _AddImageSheetState createState() => _AddImageSheetState();
}

class _AddImageSheetState extends State<_AddImageSheet> {
  bool _enableTextRecognition = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        SwitchListItem(
          title: AppLocalizations.of(context).actionAddTextFromImage,
          value: _enableTextRecognition,
          onChanged: (bool value) {
            setState(() {
              _enableTextRecognition = value;
            });
          },
        ),
        Divider(),
        ListItem(
          leading: Icon(
            OMIcons.image,
            color: Theme.of(context).accentColor,
          ),
          title: AppLocalizations.of(context).imageFromGallery,
          onTap: () => _handleMenuTapped(ImageSource.gallery),
        ),
        ListItem(
          leading: Icon(
            OMIcons.photoCamera,
            color: Theme.of(context).accentColor,
          ),
          title: AppLocalizations.of(context).imageFromCamera,
          onTap: () => _handleMenuTapped(ImageSource.camera),
        ),
      ],
    );
  }

  Future _handleMenuTapped(ImageSource source) async {
    var file = await ImagePicker.pickImage(source: source);
    Navigator.pop(
      context,
      _AddImageResult(
        file: file,
        enableTextRecognition: _enableTextRecognition,
      ),
    );
  }
}

class _AddImageResult {
  final File file;
  final bool enableTextRecognition;

  _AddImageResult({this.file, this.enableTextRecognition});

  @override
  String toString() {
    return '$runtimeType(file: $file, enableTextRecognition: $enableTextRecognition)';
  }
}
