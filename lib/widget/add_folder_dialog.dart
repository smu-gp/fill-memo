import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';

class AddFolderDialog extends StatefulWidget {
  @override
  _AddFolderDialogState createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  final _textController = TextEditingController();
  bool _validateName = false;

  @override
  Widget build(BuildContext context) {
    var bloc = BlocProvider.of<FolderBloc>(context);
    return AlertDialog(
      title: Text(AppLocalizations.of(context).actionAddFolder),
      content: TextField(
        controller: _textController,
        decoration: InputDecoration(
          errorText: _validateName
              ? AppLocalizations.of(context).errorEmptyName
              : null,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text(AppLocalizations.of(context).actionAdd),
          onPressed: () {
            var name = _textController.text.trim();
            if (name.isNotEmpty) {
              bloc.createFolder(Folder(name: name));
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
