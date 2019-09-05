import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/util/utils.dart';

class MainFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  MainFloatingActionButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      builder: (context, listState) {
        return Visibility(
          visible: true,
          child: FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.add),
            onPressed: onPressed,
            tooltip: AppLocalizations.of(context).actionAddMemo,
          ),
        );
      },
    );
  }
}
