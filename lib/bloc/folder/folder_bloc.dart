import 'package:bloc/bloc.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/repository/repository.dart';

import './folder_event.dart';
import './folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final FolderRepository repository;

  FolderBloc(this.repository) : assert(repository != null);

  @override
  FolderState get initialState => FolderLoading();

  @override
  Stream<FolderState> mapEventToState(
    FolderEvent event,
  ) async* {
    if (event is ReadFolder) {
      yield* _mapReadFolderToState(event);
    }
  }

  Stream<FolderState> _mapReadFolderToState(ReadFolder event) async* {
    try {
      await for (var list in repository.readAllAsStream()) {
        yield FolderLoaded(list);
      }
    } catch (exception) {
      yield FolderNotLoaded(exception);
    }
  }

  void createFolder(Folder newFolder) {
    repository.create(newFolder);
  }

  void updateFolder(Folder updatedFolder) {
    repository.update(updatedFolder);
  }

  void deleteFolder(String id) {
    repository.delete(id);
  }
}
