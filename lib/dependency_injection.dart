import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';

class Injector extends InheritedWidget {
  final Database database;

  Injector({
    Key key,
    @required this.database,
    @required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static Injector of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(Injector);

  @override
  bool updateShouldNotify(Injector oldWidget) => database != oldWidget.database;
}
