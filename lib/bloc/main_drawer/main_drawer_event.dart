import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MainDrawerEvent extends Equatable {
  MainDrawerEvent([List props = const []]) : super(props);
}

class SelectMenu extends MainDrawerEvent {
  final int menu;

  SelectMenu(this.menu) : super([menu]);

  @override
  String toString() => "SelectMenu{menu: $menu}";
}
