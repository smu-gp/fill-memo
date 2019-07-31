import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/util/utils.dart';

class MainFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  MainFloatingActionButton({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainDrawerBloc, MainDrawerState>(
      builder: (context, mainDrawerState) {
        return BlocBuilder<ListBloc, ListState>(
          builder: (context, listState) {
            return AnimatedOpacity(
              opacity: listState is UnSelectableList ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: FloatingActionButton(
                tooltip: AppLocalizations.of(context).actionAddMemo,
                onPressed: onPressed,
                child: Icon(Icons.add),
              ),
            );
          },
        );
      },
    );
  }
}
