import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/screen/memo_image_screen.dart';
import 'package:sp_client/service/text_process_service.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/list_item.dart';
import 'package:sp_client/widget/loading_progress.dart';
import 'package:sp_client/widget/rich_text_field/rich_text_field.dart';
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
  TextEditingController _editContentTextController;
  SpannableTextController _editContentSpannableController;

  MemoBloc _memoBloc;

  List<String> _memoContentImages;
  bool _showProgress = false;

  @override
  void initState() {
    super.initState();
    _memoBloc = BlocProvider.of<MemoBloc>(context);
    _editTitleTextController =
        TextEditingController(text: widget.memo.title ?? "");
    _editContentTextController =
        TextEditingController(text: widget.memo.content ?? "");
    if (widget.memo.contentStyle != null) {
      _editContentSpannableController = SpannableTextController.fromJson(
        sourceText: widget.memo.content ?? '',
        jsonText: widget.memo.contentStyle,
      );
    } else {
      _editContentSpannableController =
          SpannableTextController(sourceText: widget.memo.content ?? "");
    }
    _memoContentImages = []..addAll(widget.memo.contentImages ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        bottom: PreferredSize(
          child: Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.only(left: 16.0),
            child: _TitleEditText(controller: _editTitleTextController),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Visibility(
            visible: _showProgress,
            child: SizedBox(child: LinearProgressIndicator(), height: 1.0),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Visibility(
                  visible: _memoContentImages.isNotEmpty,
                  child: _ContentImageList(
                    imageList: _memoContentImages,
                    onItemTap: _handleImageItemTapped,
                  ),
                ),
                _ContentEditText(
                  autofocus: widget.memo.id == null,
                  controller: _editContentTextController,
                  spannableController: _editContentSpannableController,
                ),
              ],
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
                      onPressed: _showAddImageBottomSheet,
                    ),
                    VerticalDivider(),
                    StyleToolbar(
                      controller: _editContentSpannableController,
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

  void _handleImageItemTapped(int index) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoImageScreen(
          contentImages: _memoContentImages,
          initIndex: index,
        ),
      ),
    );
    setState(() {});
  }

  void _updateMemo() {
    var titleText = _editTitleTextController.text;
    var contentText = _editContentTextController.text;
    var contentStyleText = _editContentSpannableController.getJson();

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
          _memoBloc.updateMemo(memo);
        }
      } else {
        _memoBloc.deleteMemo(widget.memo.id);
      }
    } else {
      if (isValid) {
        _memoBloc.createMemo(memo);
      }
    }
  }

  Future _showAddImageBottomSheet() async {
    _AddImageSheetResult result = await showModalBottomSheet(
      context: context,
      builder: (context) => _AddImageSheet(),
    );
    if (result != null && result.file != null) {
      _addImage(result.file, result.enableTextRecognition);
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

  Future _addImage(File file, bool enableTextRecognition) async {
    if (enableTextRecognition) {
      _uploadProcessingServer(file);
    } else {
      _uploadFirebaseStorage(file);
    }
  }

  Future _uploadFirebaseStorage(File imageFile) async {
    final userId = _getUserId();
    final uuid = Uuid().v1();
    final ext = imageFile.path.split(".")[1];
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child(userId).child('$uuid.$ext');
    final uploadTask = storageRef.putFile(imageFile);

    setState(() {
      _showProgress = true;
    });

    final snapshot = await uploadTask.onComplete;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    _memoContentImages.add(downloadUrl);

    setState(() {
      _showProgress = false;
    });
  }

  void _uploadProcessingServer(File imageFile) async {
    var service = TextProcessService(
      httpClient: http.Client(),
      baseUrl: 'http://${AppPreferences.initServiceHost}:8000',
    );

    _showProgressDialog();

    try {
      var results = await service.sendImage(imageFile: imageFile);
      Navigator.pop(context); // Hide progress dialog
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context).titleResult),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 8.0,
              ),
              content: Container(
                width: 300,
                height: 400,
                child: ListView(
                  children: results
                      .map((result) => ListItem(
                            title: result.content,
                            onTap: () {},
                          ))
                      .toList(),
                ),
              ),
            );
          });
    } catch (e) {
      Navigator.pop(context); // Hide progress dialog
      _showSendErrorDialog(e);
    }
  }

  String _getUserId() {
    return BlocProvider.of<PreferenceBloc>(context)
        .getPreference<String>(AppPreferences.keyUserId)
        .value;
  }

  @override
  void dispose() {
    _updateMemo();
    _editTitleTextController.dispose();
    _editContentTextController.dispose();
    _editContentSpannableController.dispose();
    super.dispose();
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
          fillColor: Colors.transparent,
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
  final SpannableTextController spannableController;
  final bool autofocus;

  _ContentEditText({
    Key key,
    this.autofocus = false,
    @required this.controller,
    @required this.spannableController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Scrollbar(
          child: RichTextField(
            autofocus: autofocus,
            controller: controller,
            spannableController: spannableController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.transparent,
              hintText: AppLocalizations.of(context).hintInputNote,
            ),
          ),
        ),
      ),
    );
  }
}

class _ContentImageList extends StatelessWidget {
  final List<String> imageList;
  final ImageListCallback onItemTap;

  _ContentImageList({
    Key key,
    this.imageList = const [],
    this.onItemTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      child: (imageList.length > 1
          ? ListView(
              scrollDirection: Axis.horizontal,
              itemExtent: 360,
              children: imageList
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: _ContentImageItem(
                          url: entry.value,
                          onTap: () => onItemTap(entry.key),
                        ),
                      ))
                  .toList())
          : _ContentImageItem(
              url: imageList.first,
              onTap: () => onItemTap(0),
            )),
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
      child: Image.network(
        url,
        fit: BoxFit.fitWidth,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return LoadingProgress();
        },
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
    return Container(
      child: Wrap(
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
      ),
    );
  }

  Future _handleMenuTapped(ImageSource source) async {
    var file = await ImagePicker.pickImage(source: source);
    Navigator.pop(
      context,
      _AddImageSheetResult(
        file: file,
        enableTextRecognition: _enableTextRecognition,
      ),
    );
  }
}

class _AddImageSheetResult {
  final File file;
  final bool enableTextRecognition;

  _AddImageSheetResult({this.file, this.enableTextRecognition});

  @override
  String toString() {
    return '$runtimeType(file: $file, enableTextRecognition: $enableTextRecognition)';
  }
}
