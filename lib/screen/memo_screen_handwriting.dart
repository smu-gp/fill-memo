import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:developer' as de;

import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/model/models.dart';
import 'package:fill_memo/repository/repositories.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/localization.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:fill_memo/widget/list_item.dart';
import 'package:fill_memo/widget/painter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission/permission.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';


final _slider = PublishSubject<double>();
Observable<double> get sliderStream => _slider.stream;

class MemoHandwritingScreen extends StatefulWidget {
  final Memo memo;
  bool _finished;
  MemoHandwritingScreen(
    this.memo, {
    Key key,
  }) : super(key: key);

  @override
  _MemoHandwritingScreenState createState() => _MemoHandwritingScreenState();
}

class _MemoHandwritingScreenState extends State<MemoHandwritingScreen> {
  var _editTitleTextController = TextEditingController();
  PainterController _controller;
  Color _color;
  PictureDetails cached;
  MemoBloc _memoBloc;
  PreferenceRepository _preferenceRepository;
  Size Finishsize;
  bool _showProgress = false;
  double _progressValue = 0;
  List<String> _memoContentImages;
  bool onPicture = false;
  IconData swc;
  Color _bcolor;
  GlobalKey outCapture = new GlobalKey();
  int _curInx = 0;
  @override
  void initState() {
    super.initState();
    swc = Icons.create;
    _memoBloc = BlocProvider.of<MemoBloc>(context);
    _editTitleTextController =
        TextEditingController(text: widget.memo.title ?? "");
    _preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);
    _memoContentImages = []..addAll(widget.memo.contentImages ?? []);
    _controller = _newController();
  }

  PainterController getControllor(Memo memo, PainterController controller) {
    List<String> con = memo.content.split("ㄱ");
    String saved = con[1];
    List<String> pa = saved.split("ㄴ");
    controller.backgroundColor = Colors.white;
    for (int i = 1; i < pa.length; i++) {
      Paint currentPaint = new Paint();
      currentPaint.style = PaintingStyle.stroke;
      currentPaint.strokeCap = StrokeCap.round;

      List<String> pxyp = pa[i].split("ㅍ");

      List<String> xy = pxyp[0].split("/");

      List<String> paint = pxyp[1].split(";");

      String color = paint[0].replaceAll('paintColor(', '');
      color = color.replaceAll(')', '');
      color = color.replaceAll('0x', '');

      String th = paint[2].replaceAll('strokeWidth', '');
      currentPaint.strokeWidth = double.parse(th);
      currentPaint.color = new Color(int.parse(color, radix: 16));
      Path conp = new Path();
      conp.moveTo(double.parse(xy[1]), double.parse(xy[2]));
      MapEntry<Offset, Paint> cur = new MapEntry(
          new Offset(double.parse(xy[1]), double.parse(xy[2])), currentPaint);
      controller.pathHistory.savedpath.add(
          new MapEntry<MapEntry<Offset, Paint>, List<Offset>>(
              cur, new List<Offset>()));
      List<String> line = paint[4].split('ㄷ');
      for (int j = 1; j < line.length; j++) {
        List<String> nextxy = line[j].split('/');
        conp.lineTo(double.parse(nextxy[1]), double.parse(nextxy[2]));
        controller.pathHistory.savedpath.last.value
            .add(new Offset(double.parse(nextxy[1]), double.parse(nextxy[2])));
      }
      controller.pathHistory.paths
          .add(new MapEntry<Path, Paint>(conp, currentPaint));
    }
    controller.thickness = 5.0;
    controller.drawColor = Colors.black;

    return controller;
  }

  PainterController _newController() {
    if (widget.memo.content == null) {
      PainterController controller = new PainterController();
      controller.thickness = 5.0;
      controller.drawColor = Colors.black;
      controller.backgroundColor = Colors.white;
      return controller;
    } else {
      if (widget.memo.contentImages?.isNotEmpty) {
        PainterController controller = new PainterController();
        setState(() {
          controller.pictureOn = true;
          controller.onDrawing = new File(widget.memo.contentImages[0]);
        });
        return getControllor(widget.memo, controller);
      } else {
        PainterController controller = new PainterController();
        return getControllor(widget.memo, controller);
      }
    }
  }

  static bool isLarge(BuildContext context) {
    assert(context != null);
    var size = MediaQuery.of(context).size;
    return min(size.width, size.height) > 600;
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - kToolbarHeight - 48.0;
    Finishsize = new Size(width, height);
    List<Widget> btns;
    if (isLarge(context)) {
      if(kIsWeb){
        btns = <Widget>[
          new IconButton(
            icon: _controller.pictureOn
                ? new Icon(Icons.block)
                : new Icon(Icons.image),
            onPressed: () {
              if (!_controller.pictureOn) {
                _showAddImageBottomSheet();
              } else {
                setState(() {
                  _controller.pictureOn = !_controller.pictureOn;
                  _memoContentImages.removeLast();
                  clear(_controller);
                });
              }
            },
          ),
          new IconButton(
            icon: new Icon(Icons.save),
            onPressed: () => save(outCapture),
          ),
        ];
      }
      else{
        btns = <Widget>[
          new IconButton(
            icon: _controller.pictureOn
                ? new Icon(Icons.block)
                : new Icon(Icons.image),
            onPressed: () {
              if (!_controller.pictureOn) {
                _showAddImageBottomSheet();
              } else {
                setState(() {
                  _controller.pictureOn = !_controller.pictureOn;
                  _memoContentImages.removeLast();
                  clear(_controller);
                });
              }
            },
          ),
          new IconButton(
            icon: _controller.penOrfinger
                ? new Icon(Icons.touch_app)
                : new Icon(Icons.create),
            onPressed: () {
              setState(() {
                _controller.penOrfinger = !_controller.penOrfinger;
              });
            },
          ),
          new IconButton(
            icon: new Icon(Icons.save),
            onPressed: () => save(outCapture),
          ),
        ];
      }
    }
    else{

      btns = <Widget>[
        new IconButton(
          icon: _controller.pictureOn
              ? new Icon(Icons.block)
              : new Icon(Icons.image),

          //comeback
          onPressed: () {
            if (!_controller.pictureOn) {
              final get = _showAddImageBottomSheet();
            } else {
              setState(() {
                _controller.pictureOn = !_controller.pictureOn;
                _controller.display = null;
                _memoContentImages.removeLast();
                clear(_controller);
              });
            }
          },
        ),
        new IconButton(
          icon: new Icon(Icons.save),
          onPressed: () => save(outCapture),
        ),
      ];
    }
    de.log("build Complet");
    //comeback
    Widget w = Theme(
      data: AppThemes.lightTheme,
      child:Scaffold(
        appBar: AppBar(
          actions: btns,
          elevation: 0.0,
        ),
        body:Column(
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
            Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.only(left: 16.0),
              child: _TitleEditText(controller: _editTitleTextController),
            ),
            Expanded(
              child:new RepaintBoundary(
                  key: outCapture,
                  child: Painter(_controller)
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
                          new IconButton(
                            focusColor: _controller.drawColor,
                            icon: _controller.removeon?
                            new Icon(Icons.gesture):new Icon(Icons.delete),
                            onPressed:(){
                              setState(() {
                                _controller.removeon = !_controller.removeon;
                              });
                            }

                          ),
                          new IconButton(
                            icon: new Icon(Icons.create),
                            focusColor: _controller.drawColor,
                            onPressed: ()=> _showPenSettingBottomSheet(),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.loop),
                            focusColor: _controller.drawColor,
                            onPressed: ()=>clear(_controller),
                          ),
                        ],
                      )
                  )
              ),
            ),
          ],
        ),
      ),
    );

    return w;
  }

  void clear(PainterController controller) {
    controller.clear();
    //capturePng(controller.capture, controller,1.0);
    capturePng(outCapture, controller, 1.0);
  }

  Future<String> get _localPath async {
    var dir = await getExternalStorageDirectory();
    return dir.path;
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
        setState(() {
          _progressValue = 0;
          _showProgress = false;
        });
      }
    }
  }


  Future<File> save(GlobalKey capture) async {
    var permissionNames =
        await Permission.requestPermissions([PermissionName.Storage]);

    final path = await _localPath;

    String name = widget.memo.title +
        "_" +
        DateTime.now().millisecondsSinceEpoch.toString();
    final file = File('$path/$name.png');
    if (_controller.pictureOn) {
      final image = capturePng(_controller.capture, _controller,3.0);
      image.then((data) {
        file.writeAsBytesSync(data);
      });
    }

    else {
      final image = capturePng(_controller.noImageCap, _controller,3.0);
      image.then((data) {
        file.writeAsBytesSync(data);
      });
    }

    return file;
  }

  void _updateDrawingMemo(Size size) {
    //The error _debugLifecycleState != _ElementLifecycle.defunct is because setState is called after widget dispose()
    de.log("Pictureon :" + _controller.pictureOn.toString());

    var titleText = _editTitleTextController.text;

    var memo = widget.memo;

    memo.type = typeHandWriting;

    var contentText;

    String img;
    if (_controller.pictureOn) {
      //de.log("onDrawing :" + _controller.onDrawing.toString());
      //final image = capturePng(_controller.capture, _controller);
      //capturePng(outCapture, _controller, 1.0);
      savedInfo(memo, contentText, img, _controller.display, titleText);

    } else {
      cached = _controller.noSetFinish(size);

      Future<Uint8List> getimage;

      getimage = cached.toPNG();

      getimage.then((data) {

        savedInfo(memo, contentText, img, data, titleText);

        }, onError: (e) {});
    }
  }

  void savedInfo(Memo memo, String contentText, String img, Uint8List data,
      String titleText) {
    img = String.fromCharCodes(data);
    contentText = img.isNotEmpty ? img : null;
    contentText = contentText + 'ㄱ';
    var savedpath = _controller.pathHistory.savedpath;
    for (int i = 0; i < savedpath.length; i++) {
      contentText = contentText +
          "ㄴ/" +
          savedpath[i].key.key.dx.toString() +
          "/" +
          savedpath[i].key.key.dy.toString();
      //1,color 2.style 3.strokeWidth 4.strokeCap
      contentText = contentText +
          'ㅍ' +
          "paint" +
          savedpath[i].key.value.color.toString() +
          ';';
      contentText =
          contentText + "style" + savedpath[i].key.value.style.toString() + ';';
      contentText = contentText +
          "strokeWidth" +
          savedpath[i].key.value.strokeWidth.toString() +
          ";";
      contentText = contentText +
          "strokecap" +
          savedpath[i].key.value.strokeCap.toString() +
          ";";
      for (int j = 0; j < savedpath[i].value.length; j++) {
        contentText = contentText +
            "ㄷ/" +
            savedpath[i].value[j].dx.toString() +
            '/' +
            savedpath[i].value[j].dy.toString();
      }
    }
    var isChanged = memo.title != titleText ||
        memo.content != contentText ||
        memo.contentImages != _memoContentImages;

    memo.title = titleText.isNotEmpty ? titleText : null;
    memo.content = contentText.isNotEmpty ? contentText : null;
    memo.contentImages = _memoContentImages;

    if (isChanged) {
      memo.updatedAt = DateTime.now().millisecondsSinceEpoch;
    }

    var isValid =
        memo.title != null || _controller.pathHistory.paths.isNotEmpty;
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
  @override
  void deactivate(){

    final image = capturePng(outCapture, _controller, 1.0);
    image.then((data) {
      _updateDrawingMemo(Finishsize);

    });
    super.deactivate();
  }

  @override
  void dispose() {
    de.log("dispose-----------------------------------------------");
    _editTitleTextController.dispose();
    super.dispose();
  }


  Future<Uint8List> capturePng(
      GlobalKey capture, PainterController controller,pixelRatio) async {
    ui.Image image;
    bool catched = false;
    RenderRepaintBoundary boundary = capture.currentContext.findRenderObject();
    image = await boundary.toImage(pixelRatio: pixelRatio);
    Uint8List data = (await image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
    var redata = (await image.toByteData(format: ui.ImageByteFormat.png)).buffer.asInt8List();
    _controller.display = data;
    de.log("capturePng 실행");
    return data;

  }

  Future _showAddImageBottomSheet() async {
    _AddImageSheetResult result = await showModalBottomSheet(
      context: context,
      builder: (context) => _AddImageSheet(),
    );
    if (result != null && result.file != null) {
      if (_memoContentImages?.isEmpty) {
        _memoContentImages.add(result.file.path);
      } else {
        _memoContentImages[0] = result.file.path;
      }
      if(this.mounted){
        setState(() {
          _controller.pictureOn = true;
          _controller.onDrawing = result.file;

        });
      }


      _controller.clear();

      return await true;
    }
  }

  Future _showPenSettingBottomSheet() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => _penSettingBottomSheet(
              color: _color,
              controller: _controller,
            ));
  }
}



class _penSettingBottomSheet extends StatefulWidget {
  final Color color;
  final PainterController controller;

  _penSettingBottomSheet({
    Key key,
    this.controller,
    this.color,
  }) : super(key: key);

  @override
  _penSettingBottomSheetState createState() => _penSettingBottomSheetState();
}

class _penSettingBottomSheetState extends State<_penSettingBottomSheet> {
  Color _color;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Wrap(
      children: <Widget>[
        Row(
          children: <Widget>[
            new Container(
                width: 20,
                height: 20,
                padding: EdgeInsets.only(left: 5.0),
                child: new Icon(
                  Icons.lens,
                  color: widget.controller.drawColor,
                  size: widget.controller.thickness * 1.2,
                )),
            new Expanded(
              child: StreamBuilder(
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  return Slider(
                    activeColor: widget.controller.drawColor,
                    min: 5.0,
                    max: 20.0,
                    onChanged: (newRating) {
                      _slider.sink.add(newRating);
                      setState(() {
                        widget.controller.thickness = newRating;
                      });
                    },
                    value: widget.controller.thickness,
                  );
                },
                initialData: 0.0,
                stream: sliderStream,
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            new IconButton(
              icon: new Icon(Icons.lens),
              color: Colors.black,
              onPressed: () {
                //setState(() => widget.controller.drawColor = Colors.black);
                setState(() {
                  widget.controller.drawColor = Colors.black;
                });
              },
            ),
            new IconButton(
              icon: new Icon(Icons.lens),
              color: Colors.red,
              onPressed: () {
                //setState(() => widget.controller.drawColor = Colors.red);
                setState(() {
                  widget.controller.drawColor = Colors.red;
                });
              },
            ),
            new IconButton(
              icon: new Icon(Icons.lens),
              color: Colors.blue,
              onPressed: () {
                //setState(() => widget.controller.drawColor = Colors.blue);
                setState(() {
                  widget.controller.drawColor = Colors.blue;
                });
              },
            ),
            new IconButton(
              icon: new Icon(Icons.lens),
              color: Colors.green,
              onPressed: () {
                //setState(() => widget.controller.drawColor = Colors.green);
                setState(() {
                  widget.controller.drawColor = Colors.green;
                });
              },
            ),
            new IconButton(
              icon: new Icon(Icons.lens),
              color: Colors.purple,
              onPressed: () {
                //setState(() => widget.controller.drawColor = Colors.purple);
                setState(() {
                  widget.controller.drawColor = Colors.purple;
                });
              },
            ),
            new IconButton(
              icon: new Icon(Icons.lens),
              color: Colors.pinkAccent,
              onPressed: () {
                //setState(() => widget.controller.drawColor = Colors.pinkAccent);
                setState(() {
                  widget.controller.drawColor = Colors.pinkAccent;
                });
              },
            ),
            new IconButton(
              icon: new Icon(Icons.lens),
              color: Colors.amber,
              onPressed: () {
                //setState(() => widget.controller.drawColor = Colors.amber);
                setState(() {
                  widget.controller.drawColor = Colors.amber;
                });
              },
            ),
          ],
        )
      ],
    ));
  }

  void _showThicknessBottomSheet(context, PainterController _controller) {
    showModalBottomSheet(
        elevation: 5.0,
        context: context,
        builder: (BuildContext buildContext) {
          return StreamBuilder(
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              return Slider(
                activeColor: Colors.deepOrangeAccent,
                min: 0.0,
                max: 20.0,
                onChanged: (newRating) {
                  _slider.sink.add(newRating);
                  _controller.thickness = newRating;
                },
                value: _controller.thickness,
              );
            },
            initialData: 0.0,
            stream: sliderStream,
          );
      });
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
          focusedBorder: InputBorder.none,
          hintText: AppLocalizations.of(context).hintInputTitle,
        ),
        style: Theme.of(context).textTheme.headline,
        maxLines: 1,
        onChanged: (value) {},
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
      ),
    );
  }
}

class _AddImageSheetResult {
  final File file;

  _AddImageSheetResult({this.file});

  @override
  String toString() {
    return '$runtimeType(file: $file)';
  }
}
