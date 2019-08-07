import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/models.dart';

@immutable
abstract class FolderEvent extends Equatable {
  FolderEvent([List props = const []]) : super(props);
}

class LoadFolders extends FolderEvent {
  @override
  String toString() => '$runtimeType';
}

class AddFolder extends FolderEvent {
  final Folder folder;

  AddFolder(this.folder) : super([folder]);

  @override
  String toString() => '$runtimeType(folder: $folder)';
}

class UpdateFolder extends FolderEvent {
  final Folder updatedFolder;

  UpdateFolder(this.updatedFolder) : super([updatedFolder]);

  @override
  String toString() => '$runtimeType(updatedFolder: $updatedFolder)';
}

class DeleteFolder extends FolderEvent {
  final Folder folder;

  DeleteFolder(this.folder) : super([folder]);

  @override
  String toString() => '$runtimeType(folder: $folder)';
}

class FoldersUpdated extends FolderEvent {
  final List<Folder> folders;

  FoldersUpdated(this.folders);

  @override
  String toString() => '$runtimeType';
}

class UpdateFolderUser extends FolderEvent {
  final String userId;

  UpdateFolderUser(this.userId) : super([userId]);

  @override
  String toString() => '$runtimeType(userId: $userId)';
}
