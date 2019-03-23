import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';

class RenameFolderDialog extends StatefulWidget {
  final Folder folder;

  const RenameFolderDialog({
    Key key,
    @required this.folder,
  }) : super(key: key);

  @override
  _RenameFolderDialogState createState() => _RenameFolderDialogState();
}

class _RenameFolderDialogState extends State<RenameFolderDialog> {
  final _textController = TextEditingController();
  bool _validateName = false;

  @override
  void initState() {
    _textController.text = widget.folder.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FolderBloc>(context);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).actionRenameFolder),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(
          errorText: _validateName
              ? AppLocalizations.of(context).errorEmptyName
              : null,
        ),
        autofocus: true,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).actionRename),
          onPressed: () {
            var name = _textController.text.trim();
            if (name.isNotEmpty) {
              var updatedFolder = widget.folder..name = name;
              bloc.dispatch(UpdateFolder(updatedFolder));
              Navigator.pop(context);
            } else {
              setState(() {
                _validateName = true;
              });
            }
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
