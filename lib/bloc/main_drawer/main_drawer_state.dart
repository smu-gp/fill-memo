import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class _MainDrawerState extends Equatable {
  _MainDrawerState([List props = const []]) : super(props);
}

class MainDrawerState extends _MainDrawerState {
  final int selectedMenu;

  MainDrawerState(this.selectedMenu) : super([selectedMenu]);

  @override
  String toString() => "MainDrawerState{selectedMenu: $selectedMenu}";
}
