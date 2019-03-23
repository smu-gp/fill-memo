import 'package:equatable/equatable.dart';
import 'package:sp_client/model/models.dart';

abstract class FolderEvent extends Equatable {
  FolderEvent([List props = const []]) : super(props);
}

class LoadFolder extends FolderEvent {
  @override
  String toString() => "LoadFolder";
}

class AddFolder extends FolderEvent {
  final Folder folder;

  AddFolder(this.folder) : super([folder]);

  @override
  String toString() => 'AddFolder{folder: $folder}';
}

class UpdateFolder extends FolderEvent {
  final Folder updatedFolder;

  UpdateFolder(this.updatedFolder) : super([updatedFolder]);

  @override
  String toString() => 'UpdateFolder{updatedFolder: $updatedFolder}';
}

class DeleteFolder extends FolderEvent {
  final int folderId;

  DeleteFolder(this.folderId) : super([folderId]);

  @override
  String toString() => 'DeleteFolder{folderId: $folderId}';
}
