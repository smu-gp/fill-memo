import 'package:flutter/material.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/folder_list.dart';

class SelectFolderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Util.isLarge(context)
          ? null
          : AppBar(
              title: Text(AppLocalizations.of(context).dialogFolderSelect),
              elevation: 0.0,
            ),
      body: FolderList(
        onSelectFolder: (folder) {
          Navigator.pop(context, folder);
        },
      ),
    );
  }
}
