import 'package:flutter/widgets.dart';
import 'package:sp_client/bloc/result_bloc.dart';

class ResultBlocProvider extends StatefulWidget {
  final Widget child;
  final ResultBloc bloc;

  ResultBlocProvider({
    Key key,
    @required this.child,
    @required this.bloc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResultBlocProviderState();

  static ResultBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_ResultBlocProvider)
              as _ResultBlocProvider)
          .bloc;
}

class _ResultBlocProviderState extends State<ResultBlocProvider> {
  @override
  Widget build(BuildContext context) {
    return _ResultBlocProvider(
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

class _ResultBlocProvider extends InheritedWidget {
  final ResultBloc bloc;

  _ResultBlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_ResultBlocProvider old) => bloc != old.bloc;
}
