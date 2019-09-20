import 'dart:math' as math;

import 'package:fill_memo/bloc/blocs.dart';
import 'package:fill_memo/repository/repository.dart';
import 'package:fill_memo/util/constants.dart';
import 'package:fill_memo/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

typedef MainFabPressCallback = void Function(String type);

class MainFloatingActionButton extends StatelessWidget {
  final MainFabPressCallback onPressed;

  MainFloatingActionButton({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var preferenceRepository =
        RepositoryProvider.of<PreferenceRepository>(context);

    var quickMemoWriting =
        preferenceRepository.getBool(AppPreferences.keyQuickMemoWriting) ??
            false;

    return BlocBuilder<ListBloc, ListState>(
      builder: (context, listState) {
        return Visibility(
          visible: listState is UnSelectableList,
          child: quickMemoWriting
              ? FloatingActionButton(
                  heroTag: null,
                  child: Icon(Icons.add),
                  onPressed: () => onPressed(null),
                  tooltip: AppLocalizations.of(context).actionAddMemo,
                )
              : _MainFabWithDial(
                  onPressed: onPressed,
                ),
        );
      },
    );
  }
}

class _MainFabWithDial extends StatefulWidget {
  final MainFabPressCallback onPressed;

  _MainFabWithDial({Key key, this.onPressed}) : super(key: key);

  @override
  _MainFabWithDialState createState() => _MainFabWithDialState();
}

class _MainFabWithDialState extends State<_MainFabWithDial>
    with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, IconData> childData = {
      typeHandWriting: MdiIcons.draw,
      typeMarkdown: MdiIcons.markdown,
      typeRichText: MdiIcons.noteText,
    };

    var childFab = [];
    var index = 0;
    childData.forEach((type, icon) {
      childFab.add(_buildChildFab(icon, type, index++));
    });

    var parentChild = AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return new Transform(
          transform: new Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
          alignment: FractionalOffset.center,
          child: new Icon(_controller.isDismissed ? Icons.add : Icons.close),
        );
      },
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ...childFab,
        FloatingActionButton(
          heroTag: null,
          child: parentChild,
          onPressed: () {
            if (_controller.isDismissed) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          tooltip: AppLocalizations.of(context).actionAddMemo,
        )
      ],
    );
  }

  Widget _buildChildFab(IconData icon, String type, int index) {
    return Container(
      height: 56.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / 3 / 2.0, curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).cardColor,
          mini: true,
          child: Icon(icon, color: Theme.of(context).accentColor),
          onPressed: () {
            widget.onPressed(type);
            _controller.reverse();
          },
        ),
      ),
    );
  }
}
