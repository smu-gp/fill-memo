import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_client/model/result.dart';

class ResultItem extends StatelessWidget {
  final int index;
  final Result result;

  const ResultItem({
    Key key,
    @required this.index,
    @required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text('#${index + 1}'),
      title: (result.type == 'text'
          ? Text(result.content)
          : Image.network(result.content)),
      onTap: () {
        Clipboard.setData(ClipboardData(text: result.content));
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(result.content),
        ));
      },
    );
  }
}
