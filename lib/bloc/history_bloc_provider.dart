import 'package:flutter/widgets.dart';
import 'package:sp_client/bloc/history_bloc.dart';

class HistoryBlocProvider extends StatefulWidget {
  final Widget child;
  final HistoryBloc bloc;

  HistoryBlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryBlocProviderState();

  static HistoryBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_HistoryBlocProvider)
              as _HistoryBlocProvider)
          .bloc;
}

class _HistoryBlocProviderState extends State<HistoryBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _HistoryBlocProvider(
      bloc: widget.bloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}

class _HistoryBlocProvider extends InheritedWidget {
  final HistoryBloc bloc;

  _HistoryBlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_HistoryBlocProvider old) => bloc != old.bloc;
}
