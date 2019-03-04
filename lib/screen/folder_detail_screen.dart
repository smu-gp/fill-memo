import 'package:flutter/material.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/history_list.dart';
import 'package:sp_client/widget/sort_dialog.dart';

class FolderDetailScreen extends StatefulWidget {
  final Folder folder;
  final int historyCount;

  const FolderDetailScreen({
    Key key,
    @required this.folder,
    @required this.historyCount,
  }) : super(key: key);

  @override
  _FolderDetailScreenState createState() => _FolderDetailScreenState();
}

class _FolderDetailScreenState extends State<FolderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folder.name),
        elevation: 0.0,
        actions: _buildActions(),
      ),
      body: HistoryList(
        folderId: widget.folder.id,
      ),
    );
  }

  List<Widget> _buildActions() {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.sort),
        tooltip: AppLocalizations.of(context).actionSort,
        onPressed: () => showDialog(
              context: context,
              builder: (context) => SortDialog(),
            ),
      ),
    ];
  }
}
