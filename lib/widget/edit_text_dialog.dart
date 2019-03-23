import 'package:flutter/material.dart';

class EditTextDialog extends StatefulWidget {
  final String title;
  final String value;

  EditTextDialog({
    Key key,
    this.title,
    this.value,
  }) : super(key: key);

  @override
  _EditTextDialogState createState() => _EditTextDialogState();
}

class _EditTextDialogState extends State<EditTextDialog> {
  final _textController = TextEditingController();

  @override
  void initState() {
    _textController.text = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _textController,
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
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            var value = _textController.text.trim();
            Navigator.pop(context, value);
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
