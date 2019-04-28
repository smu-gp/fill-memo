import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preference_helper/preference_helper.dart';
import 'package:share/share.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/model/result.dart';
import 'package:sp_client/util/utils.dart';

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
    bool isText = result.type == 'text';
    String itemContent = result.content;
    if (!isText) {
      var serviceUrl = BlocProvider.of<PreferenceBloc>(context)
          .getPreference<String>(AppPreferences.keyServiceUrl)
          .value;
      itemContent = serviceUrl + result.content;
    }

    return ListTile(
      title: (isText ? Text(itemContent) : Image.network(itemContent)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: (isText
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.content_copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: itemContent));
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Copied \"$itemContent\""),
                    ));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share(itemContent);
                  },
                ),
              ]
            : []),
      ),
    );
  }
}
