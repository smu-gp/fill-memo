import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class MainDrawerEvent extends Equatable {
  MainDrawerEvent([List props = const []]) : super(props);
}

class SelectMenu extends MainDrawerEvent {
  final int menu;
  final String folderId;

  SelectMenu(this.menu, {this.folderId}) : super([menu, folderId]);

  @override
  String toString() {
    return 'SelectMenu{menu: $menu, folderId: $folderId}';
  }
}
