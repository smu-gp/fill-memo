import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/localization.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/rich_text_field/rich_text_field.dart';

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
  var _editTitleTextController = TextEditingController();
  var _editContentTextController = TextEditingController();
  var _editContentSpannableController = SpannableTextController();

  MemoBloc _memoBloc;

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
          Expanded(
            child: _ContentEditText(
              autofocus: widget.memo.id == null,
              controller: _editContentTextController,
              spannableController: _editContentSpannableController,
            ),
          ),
          Material(
            elevation: 4.0,
            child: Container(
              height: 48.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: StyleToolbar(
                  controller: _editContentSpannableController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateMemo() {
    var titleText = _editTitleTextController.text;
    var contentText = _editContentTextController.text;
    var contentStyleText = _editContentSpannableController.getJson();

    var memo = widget.memo;
    memo.title = titleText.isNotEmpty ? titleText : null;
    memo.content = contentText.isNotEmpty ? contentText : null;
    memo.contentStyle = contentStyleText.isNotEmpty ? contentStyleText : null;
    memo.updatedAt = DateTime.now().millisecondsSinceEpoch;
    if (widget.memo.id != null) {
      _memoBloc.updateMemo(memo);
    } else {
      _memoBloc.createMemo(memo);
    }
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
    );
  }
}
