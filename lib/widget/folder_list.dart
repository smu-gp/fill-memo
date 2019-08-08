import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/loading_progress.dart';

typedef FolderSelectCallback = void Function(Folder);

class FolderList extends StatelessWidget {
  final FolderSelectCallback onSelectFolder;

  const FolderList({
    Key key,
    this.onSelectFolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderBloc, FolderState>(
      builder: (BuildContext context, FolderState state) {
        if (state is FoldersLoaded) {
          var folders = [
            Folder(
              name: AppLocalizations.of(context).folderDefault,
            ),
          ]..addAll(state.folders);
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Icon(
                  Icons.folder,
                  color: Colors.grey,
                ),
                title: Text(folders[index].name),
                onTap: () {
                  onSelectFolder(folders[index]);
                },
              );
            },
            itemCount: folders.length,
            separatorBuilder: (context, index) => Divider(height: 1),
            shrinkWrap: true,
          );
        } else {
          return LoadingProgress();
        }
      },
    );
  }
}
