import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/repository/repository.dart';

import 'folder_event.dart';
import 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final FolderRepository _folderRepository;
  StreamSubscription _folderSubscription;

  FolderBloc({@required FolderRepository folderRepository})
      : assert(folderRepository != null),
        _folderRepository = folderRepository;

  @override
  FolderState get initialState => FoldersLoading();

  @override
  Stream<FolderState> mapEventToState(
    FolderEvent event,
  ) async* {
    if (event is LoadFolders) {
      yield* _mapLoadFoldersToState(event);
    } else if (event is AddFolder) {
      yield* _mapAddFolderToState(event);
    } else if (event is UpdateFolder) {
      yield* _mapUpdateFolderToState(event);
    } else if (event is DeleteFolder) {
      yield* _mapDeleteFolderToState(event);
    } else if (event is FoldersUpdated) {
      yield* _mapFoldersUpdateToState(event);
    } else if (event is UpdateFolderUser) {
      yield* _mapUpdateFolderUserToState(event);
    }
  }

  Stream<FolderState> _mapLoadFoldersToState(LoadFolders event) async* {
    _folderSubscription?.cancel();
    _folderSubscription = _folderRepository.folders().listen((folders) {
      dispatch(
        FoldersUpdated(folders),
      );
    });
  }

  Stream<FolderState> _mapAddFolderToState(AddFolder event) async* {
    _folderRepository.addNewFolder(event.folder);
  }

  Stream<FolderState> _mapUpdateFolderToState(UpdateFolder event) async* {
    _folderRepository.updateFolder(event.updatedFolder);
  }

  Stream<FolderState> _mapDeleteFolderToState(DeleteFolder event) async* {
    _folderRepository.deleteFolder(event.folder);
  }

  Stream<FolderState> _mapFoldersUpdateToState(FoldersUpdated event) async* {
    yield FoldersLoaded(event.folders);
  }

  Stream<FolderState> _mapUpdateFolderUserToState(
      UpdateFolderUser event) async* {
    _folderRepository.updateUserId(event.userId);
    dispatch(LoadFolders());
  }
}
