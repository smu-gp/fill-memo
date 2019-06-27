import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/screen/memo_title_screen.dart';
import 'package:sp_client/util/utils.dart';

class MainFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainDrawerEvent, MainDrawerState>(
      bloc: BlocProvider.of<MainDrawerBloc>(context),
      builder: (context, mainDrawerState) {
        return BlocBuilder<ListEvent, ListState>(
          bloc: BlocProvider.of<ListBloc>(context),
          builder: (context, listState) {
            return AnimatedOpacity(
              opacity: listState is UnSelectableList ? 1.0 : 0.0,
              duration: Duration(milliseconds: 200),
              child: FloatingActionButton(
                tooltip: AppLocalizations.of(context).actionAddMemo,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemoTitleScreen(),
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
            );
          },
        );
      },
    );
  }
}
