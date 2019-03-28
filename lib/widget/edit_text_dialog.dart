import 'package:flutter/material.dart';

typedef ValidationCallback = bool Function(String value);

class EditTextDialog extends StatefulWidget {
  final String title;
  final String value;
  final ValidationCallback validation;
  final String validationMessage;

  EditTextDialog({
    Key key,
    this.title,
    this.value,
    this.validation,
    this.validationMessage,
  }) : super(key: key);

  @override
  _EditTextDialogState createState() => _EditTextDialogState();
}

class _EditTextDialogState extends State<EditTextDialog> {
  final _textController = TextEditingController();

  bool _validationFailed = false;

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
        decoration: InputDecoration(
          errorText: _validationFailed ? widget.validationMessage : null,
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
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
          onPressed: () {
            var value = _textController.text.trim();
            if (widget.validation(value)) {
              Navigator.pop(context, value);
            } else {
              setState(() {
                _validationFailed = true;
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
