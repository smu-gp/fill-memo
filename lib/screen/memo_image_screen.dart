import 'package:fill_memo/widget/loading_progress.dart';
import 'package:fill_memo/widget/network_image.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class MemoImageScreen extends StatefulWidget {
  final List<String> contentImages;
  final String heroTagId;
  final int initIndex;

  MemoImageScreen({
    Key key,
    this.contentImages,
    this.heroTagId,
    this.initIndex,
  }) : super(key: key);

  @override
  _MemoImageScreenState createState() => _MemoImageScreenState();
}

class _MemoImageScreenState extends State<MemoImageScreen> {
  PageController _pageController;

  int _currentPageIndex;
  List<String> _contentImages;

  String get indexTitle => "${_currentPageIndex + 1}/${_contentImages.length}";

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initIndex;
    _contentImages = widget.contentImages;
    _pageController = PageController(initialPage: widget.initIndex);
    _pageController.addListener(() {
      setState(() {
        _currentPageIndex = _pageController.page.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_currentPageIndex + 1}/${_contentImages.length}"),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(OMIcons.delete),
            onPressed: () {
              _contentImages.removeAt(_currentPageIndex);
              if (_contentImages.isEmpty) {
                Navigator.pop(context);
              } else {
                setState(() {});
              }
            },
          )
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: _contentImages.length,
        itemBuilder: (BuildContext context, int index) {
          return Hero(
            tag: "image_${widget.heroTagId}_$index",
            child: Material(
              child: PlatformNetworkImage(
                url: _contentImages[index],
                placeholder: LoadingProgress(),
              ),
            ),
          );
        },
        pageSnapping: true,
      ),
    );
  }
}
