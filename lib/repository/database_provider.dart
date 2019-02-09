import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider extends StatefulWidget {
  final Widget child;
  final Database db;

  DatabaseProvider({
    Key key,
    @required this.child,
    @required this.db,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DatabaseProviderState();

  static Database of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(_DatabaseProvider)
              as _DatabaseProvider)
          .db;
}

class _DatabaseProviderState extends State<DatabaseProvider> {
  @override
  Widget build(BuildContext context) {
    return _DatabaseProvider(
      db: widget.db,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    widget.db.close();
    super.dispose();
  }
}

class _DatabaseProvider extends InheritedWidget {
  final Database db;

  _DatabaseProvider({
    Key key,
    @required this.db,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_DatabaseProvider old) => db != old.db;
}
