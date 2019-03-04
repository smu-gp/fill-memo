import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/folder_bloc.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/widget/folder_item.dart';
import 'package:sp_client/widget/loading_progress.dart';

class FolderList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderEvent, FolderState>(
      bloc: BlocProvider.of<FolderBloc>(context),
      builder: (BuildContext context, FolderState state) {
        if (state is FolderLoaded) {
          var folders = [
            Folder(id: 0, name: 'Default'),
          ]..addAll(state.folders);
          return OrientationBuilder(
              builder: (context, Orientation orientation) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: (orientation == Orientation.portrait ? 2 : 4),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                children: folders.map<Widget>((folder) {
                  return FolderItem(
                    folder: folder,
                  );
                }).toList(),
              ),
            );
          });
        } else {
          return LoadingProgress();
        }
      },
    );
  }
}
