import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class _MainDrawerState extends Equatable {
  _MainDrawerState([List props = const []]) : super(props);
}

class MainDrawerState extends _MainDrawerState {
  final int selectedMenu;
  final String folderId;

  MainDrawerState(this.selectedMenu, {this.folderId})
      : super([selectedMenu, folderId]);

  @override
  String toString() {
    return 'MainDrawerState{selectedMenu: $selectedMenu, folderId: $folderId}';
  }
}
