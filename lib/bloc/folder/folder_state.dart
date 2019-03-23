import 'package:equatable/equatable.dart';
import 'package:sp_client/model/models.dart';

abstract class FolderState extends Equatable {
  FolderState([List props = const []]) : super(props);
}

class FolderLoading extends FolderState {
  @override
  String toString() => 'FolderLoading';
}

class FolderLoaded extends FolderState {
  final List<Folder> folders;

  FolderLoaded([this.folders = const []]) : super([folders]);

  @override
  String toString() => 'FolderLoaded{folders: $folders}';
}

class FolderNotLoaded extends FolderState {
  @override
  String toString() => 'FolderNotLoaded';
}
