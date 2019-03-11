import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';

typedef FolderSelectCallback = void Function(Folder);

class FolderList extends StatelessWidget {
  final FolderSelectCallback onSelectFolder;

  const FolderList({
    Key key,
    this.onSelectFolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderEvent, FolderState>(
      bloc: BlocProvider.of<FolderBloc>(context),
      builder: (BuildContext context, FolderState state) {
        if (state is FolderLoaded) {
          var folders = [
            Folder(id: 0, name: AppLocalizations.of(context).folderDefault),
          ]..addAll(state.folders);
          return ListView.builder(
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
            shrinkWrap: true,
          );
        }
      },
    );
  }
}
