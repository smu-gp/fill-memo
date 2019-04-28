import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/utils.dart';
import 'package:sp_client/widget/folder_grid_item.dart';
import 'package:sp_client/widget/loading_progress.dart';

class FolderGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FolderEvent, FolderState>(
      bloc: BlocProvider.of<FolderBloc>(context),
      builder: (BuildContext context, FolderState state) {
        if (state is FolderLoaded) {
          var folders = [
            Folder(id: 0, name: AppLocalizations.of(context).folderDefault),
          ]..addAll(state.folders);
          return OrientationBuilder(
              builder: (context, Orientation orientation) {
            return GridView.count(
              padding: EdgeInsets.symmetric(
                horizontal: Util.isTablet(context) ? 32.0 : 16.0,
                vertical: Util.isTablet(context) ? 32.0 : 16.0,
              ),
              crossAxisCount: (Util.isTablet(context)
                  ? 6
                  : orientation == Orientation.portrait ? 2 : 4),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: folders.map<Widget>((folder) {
                return FolderGridItem(
                  folder: folder,
                );
              }).toList(),
            );
          });
        } else {
          return LoadingProgress();
        }
      },
    );
  }
}
