import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/history_bloc.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/screen/folder_detail_screen.dart';
import 'package:sp_client/widget/history_image.dart';

class FolderItem extends StatelessWidget {
  final Folder folder;

  const FolderItem({
    Key key,
    @required this.folder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var historyState = BlocProvider.of<HistoryBloc>(context).currentState;
    if (historyState is HistoryLoaded) {
      var histories = historyState.histories
          .where((history) => history.folderId == folder.id)
          .toList();
      histories.sort((a, b) => -a.createdAt.compareTo(b.createdAt));
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FolderDetailScreen(
                        folder: folder,
                        historyCount: histories.length,
                      ),
                ));
          },
          child: GridTile(
            child: (histories.isNotEmpty
                ? HistoryImage(
                    history: histories.first,
                  )
                : Container(
                    color: Colors.grey,
                  )),
            footer: GridTileBar(
              backgroundColor: Colors.black26,
              title: Center(
                child: Text(folder.name),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Center(
                  child: Text('${histories.length}'),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
