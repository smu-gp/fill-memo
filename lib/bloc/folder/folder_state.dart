import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class FolderState extends Equatable {
  FolderState([List props = const []]) : super(props);
}

class FoldersLoading extends FolderState {
  @override
  String toString() => '$runtimeType';
}

class FoldersLoaded extends FolderState {
  final List<Folder> folders;

  FoldersLoaded([this.folders = const []]) : super([folders]);

  @override
  String toString() => '$runtimeType(folders: $folders)';
}

class FoldersNotLoaded extends FolderState {
  final Exception exception;

  FoldersNotLoaded(this.exception) : super([exception]);

  @override
  String toString() => '$runtimeType(exception: $exception)';
}
