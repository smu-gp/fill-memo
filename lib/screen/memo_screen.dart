import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/localization.dart';

class MemoScreen extends StatefulWidget {
  final String id;
  final String title;
  final Folder folder;

  MemoScreen({
    this.id,
    this.title,
    this.folder,
    Key key,
  }) : super(key: key);

  @override
  _MemoScreenState createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  final _editTitleTextController = TextEditingController();
  final _editContentTextController = TextEditingController();

  MemoBloc _memoBloc;
  Memo _currentMemo;

  @override
  void initState() {
    super.initState();
    _memoBloc = BlocProvider.of<MemoBloc>(context);
    _editTitleTextController.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        bottom: PreferredSize(
          child: Container(
            height: kToolbarHeight,
            padding: const EdgeInsets.only(left: 4.0),
            child: _TitleEditText(controller: _editTitleTextController),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight),
        ),
        elevation: 0.0,
      ),
      body: StreamBuilder<Memo>(
        stream: _memoBloc.readMemo(widget.id),
        builder: (context, snapshot) {
          _currentMemo = (snapshot.hasData ? snapshot.data : null);
          if (_currentMemo != null) {
            _editContentTextController.text = _currentMemo.content;
          }
          return Theme(
            data: Theme.of(context).copyWith(splashColor: Colors.transparent),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: TextField(
                autofocus: widget.id == null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Colors.transparent,
                  hintText: AppLocalizations.of(context).hintInputNote,
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _editContentTextController,
                onChanged: (value) {},
              ),
            ),
          );
        },
      ),
    );
  }

  void _updateMemo() {
    var titleText = _editTitleTextController.text;
    var contentText = _editContentTextController.text;
    if (widget.id != null) {
      _currentMemo.title = titleText.isNotEmpty ? titleText : null;
      _currentMemo.content = contentText;
      _memoBloc.updateMemo(_currentMemo);
    } else {
      var newMemo = Memo(
        folderId: widget.folder != null ? widget.folder.id : null,
        title: titleText.isNotEmpty ? titleText : null,
        content: contentText.isNotEmpty ? contentText : "",
        createdAt: DateTime.now().millisecondsSinceEpoch,
        type: "plainText",
      );
      _memoBloc.createMemo(newMemo);
    }
  }

  @override
  void dispose() {
    _updateMemo();
    _editTitleTextController.dispose();
    _editContentTextController.dispose();
    super.dispose();
  }
}

class _TitleEditText extends StatelessWidget {
  final TextEditingController controller;

  _TitleEditText({
    this.controller,
  });

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
        style: Theme.of(context)
            .textTheme
            .headline
            .copyWith(fontWeight: FontWeight.bold),
        maxLines: 1,
        onChanged: (value) {},
      ),
    );
  }
}
