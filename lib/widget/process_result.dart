import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sp_client/bloc/blocs.dart';
import 'package:sp_client/model/models.dart';
import 'package:sp_client/util/localization.dart';

import 'list_item.dart';

class ProcessResultPanel extends StatefulWidget {
  final List<ProcessResult> results;

  ProcessResultPanel({
    Key key,
    this.results,
  }) : super(key: key);

  @override
  ProcessResultPanelState createState() => ProcessResultPanelState();
}

class ProcessResultPanelState extends State<ProcessResultPanel> {
  ListBloc _listBloc = ListBloc();

  List<dynamic> get selectedItems => _listBloc.currentState is SelectableList
      ? (_listBloc.currentState as SelectableList).selectedItems
      : null;

  @override
  void initState() {
    super.initState();
    _listBloc.dispatch(Selectable());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ListBloc, ListState>(
      bloc: _listBloc,
      builder: (context, state) {
        List<dynamic> selectedItems;
        var allSelected = false;
        if (state is SelectableList) {
          selectedItems = state.selectedItems;
          allSelected = selectedItems?.length == widget.results.length;
        }

        return Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColorDark,
              child: SelectableListItem(
                title: AppLocalizations.of(context).actionSelectionAll,
                selectable: true,
                selected: allSelected,
                onTap: () {
                  widget.results.forEach((result) {
                    if (allSelected) {
                      _listBloc.dispatch(UnSelectItem(result));
                    } else {
                      _listBloc.dispatch(SelectItem(result));
                    }
                  });
                },
                onCheckboxChanged: (bool value) {
                  widget.results.forEach((result) {
                    if (value) {
                      _listBloc.dispatch(SelectItem(result));
                    } else {
                      _listBloc.dispatch(UnSelectItem(result));
                    }
                  });
                },
                onLongPress: () {},
              ),
            ),
            ListView.separated(
              itemBuilder: (context, index) {
                var result = widget.results[index];
                var selected = false;
                if (selectedItems != null) {
                  selected = selectedItems.contains(result);
                }

                return SelectableListItem(
                  title: result.content,
                  selectable: true,
                  selected: selected,
                  onCheckboxChanged: (bool value) {
                    if (value) {
                      _listBloc.dispatch(SelectItem(result));
                    } else {
                      _listBloc.dispatch(UnSelectItem(result));
                    }
                  },
                  onTap: () {
                    if (selected) {
                      _listBloc.dispatch(UnSelectItem(result));
                    } else {
                      _listBloc.dispatch(SelectItem(result));
                    }
                  },
                  onLongPress: () {},
                );
              },
              separatorBuilder: (context, index) => Divider(height: 1),
              itemCount: widget.results.length,
              shrinkWrap: true,
            ),
          ],
        );
      },
    );
  }
}
