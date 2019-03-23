import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/history.dart';
import 'package:sp_client/screen/result_screen.dart';
import 'package:sp_client/widget/history_image.dart';

class HistoryItem extends StatelessWidget {
  final History history;
  final bool selectable;
  final bool selected;

  const HistoryItem({
    Key key,
    @required this.history,
    this.selectable = false,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var historyListBloc = BlocProvider.of<HistoryListBloc>(context);
    return InkWell(
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: HistoryImage(
              history: history,
            ),
          ),
          AnimatedOpacity(
            opacity: selected ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: Container(
              color: Colors.black26,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        if (selectable) {
          historyListBloc.dispatch(
              (selected ? UnSelectItem(history) : SelectItem(history)));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(
                    history: history,
                  ),
            ),
          );
        }
      },
      onLongPress: () {
        if (historyListBloc.currentState is UnSelectableList) {
          historyListBloc.dispatch(SelectItem(history));
        }
      },
    );
  }
}
