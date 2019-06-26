import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/screen/memo_screen.dart';
import 'package:sp_client/util/localization.dart';

class MemoTitleScreen extends StatefulWidget {
  @override
  _MemoTitleScreenState createState() => _MemoTitleScreenState();
}

class _MemoTitleScreenState extends State<MemoTitleScreen> {
  final _editTextController = TextEditingController();

  FolderBloc _folderBloc;

  bool _backgroundTextVisible = false;
  Folder _currentFolder;

  @override
  void initState() {
    super.initState();
    _folderBloc = BlocProvider.of<FolderBloc>(context);
    _editTextController.addListener(_updateFolder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(""),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(),
            _MemoTitleEditText(
              controller: _editTextController,
              backgroundTextVisible: _backgroundTextVisible,
              onSubmitted: (text) => _navigateMemoScreen(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                  child: _FolderChip(_currentFolder),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0, right: 8.0),
                  child: FloatingActionButton(
                    child: Icon(Icons.arrow_forward),
                    onPressed: _navigateMemoScreen,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editTextController.dispose();
    super.dispose();
  }

  void _updateFolder() {
    var words = _editTextController.text.split(" ");
    var findFolder;
    if (words.length >= 1) {
      var folderState = _folderBloc.currentState;
      if (folderState is FolderLoaded) {
        folderState.folders.forEach((folder) {
          if (folder.name == words.first) {
            findFolder = folder;
          }
        });
      }
    }
    setState(() {
      _currentFolder = findFolder;
    });
  }

  void _navigateMemoScreen() async {
    setState(() {
      _backgroundTextVisible = true;
    });

    var title = _editTextController.text;
    if (_currentFolder != null) {
      if (title.length > _currentFolder.name.length + 1) {
        title = title.substring(_currentFolder.name.length + 1);
      } else {
        title = null;
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MemoScreen(
          title: title,
          folder: _currentFolder,
        ),
      ),
    );
  }
}

class _MemoTitleEditText extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final bool backgroundTextVisible;

  _MemoTitleEditText({
    Key key,
    @required this.controller,
    this.onSubmitted,
    this.backgroundTextVisible,
  }) : super(key: key);

  @override
  _MemoTitleEditTextState createState() => _MemoTitleEditTextState();
}

class _MemoTitleEditTextState extends State<_MemoTitleEditText> {
  String _currentText = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        Visibility(
          visible: !widget.backgroundTextVisible,
          child: TextField(
            textInputAction: TextInputAction.go,
            controller: widget.controller,
            onChanged: (text) {
              setState(() {
                _currentText = text;
              });
            },
            onSubmitted: widget.onSubmitted,
            autofocus: true,
            style: Theme.of(context)
                .textTheme
                .headline
                .copyWith(fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.transparent,
              hintText: AppLocalizations.of(context).hintInputTitle,
            ),
          ),
        ),
        Visibility(
          visible: widget.backgroundTextVisible,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Hero(
              tag: "memoTitle",
              child: Material(
                color: Colors.transparent,
                child: Text(
                  _currentText,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _FolderChip extends StatelessWidget {
  final Folder folder;

  _FolderChip(this.folder);

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.all(4.0),
      label: Text(
        folder?.name ?? AppLocalizations.of(context).folderDefault,
      ),
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(
          Icons.folder,
          color: Colors.grey,
        ),
      ),
    );
  }
}
