import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/repository/repositories.dart';
import 'package:sp_client/util/constants.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/painter.dart';
import 'package:sp_client/widget/rich_text_field/rich_text_field.dart';

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:sp_client/widget/list_item.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sp_client/util/routes.dart';
import 'package:uuid/uuid.dart';

import 'dart:ui' as ui;

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

  bool onPicture=false;

  GlobalKey outCapture = new GlobalKey();

  int _curInx=0;


  @override
  void initState() {
    super.initState();
    _memoBloc = BlocProvider.of<MemoBloc>(context);
    _editTitleTextController =
        TextEditingController(text: widget.memo.title ?? "");
    _preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);
    _memoContentImages = []..addAll(widget.memo.contentImages ?? []);
    _controller=_newController();
  }

  PainterController getControllor(Memo memo,PainterController controller){

    List<String> con = memo.content.split("ㄱ");
    String saved = con[1];
    List<String> pa = saved.split("ㄴ");
    controller.backgroundColor=Colors.white;
    for(int i=1; i< pa.length; i++){
      Paint currentPaint = new Paint();
      currentPaint.style=PaintingStyle.stroke;
      currentPaint.strokeCap=StrokeCap.round;

      List<String> pxyp= pa[i].split("ㅍ");

      List<String> xy =  pxyp[0].split("/");

      List<String> paint = pxyp[1].split(";");

      String color = paint[0].replaceAll('paintColor(', '');
      color = color.replaceAll(')', '');
      color = color.replaceAll('0x', '');

      String th = paint[2].replaceAll('strokeWidth', '');
      currentPaint.strokeWidth=double.parse(th);
      currentPaint.color= new Color(int.parse(color, radix:16));
      Path conp = new Path();
      conp.moveTo(double.parse(xy[1]), double.parse(xy[2]));
      MapEntry<Offset,Paint> cur = new MapEntry(new Offset(double.parse(xy[1]), double.parse(xy[2])), currentPaint);
      controller.pathHistory.savedpath.add(new MapEntry<MapEntry<Offset,Paint>,List<Offset>>(cur, new List<Offset>()));
      List<String> line = paint[4].split('ㄷ');
      for(int j=1; j<line.length; j++){
        List<String> nextxy = line[j].split('/');
        conp.lineTo(double.parse(nextxy[1]), double.parse(nextxy[2]));
        controller.pathHistory.savedpath.last.value.add(new Offset(double.parse(nextxy[1]), double.parse(nextxy[2])));
      }
      controller.pathHistory.paths.add(new MapEntry<Path, Paint>(conp,currentPaint));
    }
    controller.thickness = 5.0;
    controller.drawColor=Colors.black;
    return controller;
  }

  PainterController _newController() {

    if(widget.memo.content == null){
      PainterController controller = new PainterController();
      controller.thickness = 5.0;
      controller.drawColor=Colors.black;
      controller.backgroundColor=Colors.white;
      return controller;
    }
    else{
      if(widget.memo.contentImages?.isNotEmpty != false){
        PainterController controller = new PainterController();
        controller.pictureOn = true;
        controller.onDrawing=new File(widget.memo.contentImages[0]);
        return getControllor(widget.memo,controller);
      }
      else{
        PainterController controller = new PainterController();
        return getControllor(widget.memo,controller);
      }
    }
  }

  void _onItemTapped(int index) {
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height - kToolbarHeight-48.0;
    Finishsize = new Size(width,height);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _controller.backgroundColor,
        title: Text(""),
        actions: <Widget>[
          new IconButton(
              icon:new Icon(Icons.undo),
              onPressed: ()=>undo(_controller),
          ),
        ],
        //bottom: PreferredSize(
        //  child: Container(
        //    height: kToolbarHeight+3,
        //    padding: const EdgeInsets.only(left: 16.0),
        //    child: _TitleEditText(controller: _editTitleTextController),
        //  ),
        //  preferredSize: Size.fromHeight(kToolbarHeight),
        //),
        elevation: 0.0,
      ),
      body: Center(
        child: new RepaintBoundary(
          key : outCapture,
           child: Painter(_controller)
        ),
      ),
      bottomNavigationBar : BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.create,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.create,
              size: 30,
              color: Colors.blue,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.color_lens,
              color: Colors.black,),
            activeIcon: Icon(
              Icons.color_lens,
              size: 30,
              color: Colors.blue,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.clear,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.clear,
              size: 30,
              color: Colors.blue,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.delete,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.delete,
              size: 30,
              color: Colors.blue,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              OMIcons.image,
              color: Colors.black,
            ),
            activeIcon: Icon(
              OMIcons.image,
              size: 30,
              color: Colors.blue,
            ),
            title: Text(""),
          ),
        ],
        selectedItemColor: Colors.amber[800],
        currentIndex: _curInx,
        onTap: (index){
          setState(() {
            _curInx = index;
            switch(index){
              case 0:
                restart();
                break;
              case 1:
                _showPenSettingBottomSheet();
                break;
              case 2:
                clear(_controller);
                break;
              case 3:
                _controller.erase();
                break;
              case 4:
                _showAddImageBottomSheet();
                break;
            }
          });
        },
      ),
    );
  }
  
  void clear(PainterController controller){
    controller.clear();
    capturePng(controller.capture, controller);
  }

  void undo(PainterController controller){
    controller.undo();
    capturePng(controller.capture, controller);
  }
  
  void _updateDrawingMemo(Size size){
    //The error _debugLifecycleState != _ElementLifecycle.defunct is because setState is called after widget dispose()

    var titleText = _editTitleTextController.text;

    var memo = widget.memo;

    memo.type = typeHandWriting;

    var contentText;

    //Finishsize = MediaQuery.of(context).size;
    //Future<Uint8List> getimage =  cached.toPNG();
    String img;
    if(_controller.pictureOn){
      log("_controller.display : " + _controller.display.toString());
      savedInfo(memo, contentText, img, _controller.display, titleText);
    }
    else{
      cached = _controller.noSetFinish(size);
      Future<Uint8List> getimage;
      getimage =  cached.toPNG();
      getimage.then((data){
        savedInfo(memo, contentText, img, data, titleText);

      },onError: (e)
      {
      });
    }
    //log("contentImg: "+ img);

  }

  void savedInfo(Memo memo, String contentText, String img,Uint8List data,String titleText){
    img = String.fromCharCodes(data);
    contentText = img.isNotEmpty ? img : null;
    contentText = contentText+'ㄱ';
    var savedpath = _controller.pathHistory.savedpath;
    for(int i=0; i<savedpath.length;i++){
      contentText= contentText+"ㄴ/"+savedpath[i].key.key.dx.toString()+"/"+savedpath[i].key.key.dy.toString();
      //1,color 2.style 3.strokeWidth 4.strokeCap
      contentText = contentText+'ㅍ' + "paint"+ savedpath[i].key.value.color.toString()+';';
      contentText = contentText + "style"+ savedpath[i].key.value.style.toString()+';';
      contentText = contentText + "strokeWidth" + savedpath[i].key.value.strokeWidth.toString()+";";
      contentText = contentText + "strokecap" + savedpath[i].key.value.strokeCap.toString()+";";
      for(int j=0; j< savedpath[i].value.length;j++){
        contentText = contentText + "ㄷ/" + savedpath[i].value[j].dx.toString()+'/' + savedpath[i].value[j].dy.toString();
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

    var isValid = memo.title != null || _controller.pathHistory.paths.isNotEmpty;
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


  void dispose() {
   _updateDrawingMemo(Finishsize);
   _editTitleTextController.dispose();
   super.dispose();
  }


  void restart(){
    _controller.removeon=false;
  }


  //Future<Uint8List> capturePng(GlobalKey capture) async {
  //  ui.Image image;
  //  bool catched = false;
  //  RenderRepaintBoundary boundary = capture.currentContext.findRenderObject();
  //  try{
  //    image = await boundary.toImage();
  //    catched = true;
  //  }catch(exception){
  //    catched = false;
  //    Timer(Duration(milliseconds: 1),() {
  //      capturePng(capture);
  //    });
  //  }
  //  if(catched){
  //    return (await image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  //  }
 // }

  Future<void> capturePng(GlobalKey capture, PainterController controller) async{
    ui.Image image;
    bool catched = false;
    RenderRepaintBoundary boundary = capture.currentContext.findRenderObject();
    try{
      image = await boundary.toImage();
      catched = true;
    }catch(exception){
      catched = false;
      Timer(Duration(milliseconds: 1),(){
        capturePng(capture, controller);
      });
    }
    if(catched) {
      Uint8List data = (await image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
      setState(() {
        _controller.display = data;
      });
    }
  }

  Future _showAddImageBottomSheet() async {
    _AddImageSheetResult result = await showModalBottomSheet(
      context: context,
      builder: (context) => _AddImageSheet(),
    );
    if(result != null && result.file != null){
      if(_memoContentImages?.isEmpty){
        _memoContentImages.add(result.file.path);
      }
      else{
        _memoContentImages[0] = result.file.path;
      }
      setState(() {
        _controller.pictureOn = true;
        _controller.onDrawing = result.file;
      });
      capturePng(outCapture ,_controller);
    }
  }





  Future _showPenSettingBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) => _penSettingBottomSheet(
        color: _color,
        controller: _controller,
      )
    );
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
          ListItem(
            leading: Icon(
                Icons.color_lens,
                color: Colors.deepOrangeAccent,
            ),
            title: '펜 색깔',
            onTap: () => _openColorPicker(),
          ),
          ListItem(
            leading: Icon(
              Icons.border_color,
              color: Colors.deepOrangeAccent,
            ),
            title: '펜 굵기',
            onTap: () => _showThicknessBottomSheet(context, widget.controller),
          )
        ],
      ),
    );
  }

  void _openColorPicker() async {
    _openDialog(
      MaterialColorPicker(
        selectedColor: _color,
        onColorChange: (color) => setState(() => _color = color),

      ),
    );
  }

  void _openDialog(Widget content) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(6.0),
            content: content,
            actions: [
              FlatButton(
                child: Text('CANCEL'),
                onPressed: Navigator.of(context).pop,
              ),
              FlatButton(
                child: Text('SUBMIT'),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() => widget.controller.drawColor = _color);
                },
              ),
            ],
          );
        }
    );
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
                max: 15.0,
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
        }

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
          prefixIcon: Icon(
            Icons.description,
            size: 30,
            color: Colors.amber,
          ),
          //border: InputBorder.none,
          //border: UnderlineInputBorder(
          //  borderSide: BorderSide(
          //    color: Colors.amber,
          //  ),
          //),
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

