import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sp_client/model/folder.dart';
import 'package:sp_client/repository/base_repository.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final BaseFolderRepository folderRepository;

  FolderBloc({@required this.folderRepository})
      : assert(folderRepository != null);

  @override
  FolderState get initialState => FolderLoading();

  @override
  Stream<FolderState> mapEventToState(
    FolderState currentState,
    FolderEvent event,
  ) async* {
    if (event is FetchFolder) {
      var list = await folderRepository.readAll();
      yield FolderLoaded(folders: list);
    }
  }

  Future<Folder> createFolder(Folder newObject) {
    var created = folderRepository.create(newObject);
    if (currentState is FolderLoaded) {
      dispatch(FetchFolder());
    }
    return created;
  }

  Future<bool> updateFolder(Folder folder) {
    var updated = folderRepository.update(folder);
    if (currentState is FolderLoaded) {
      dispatch(FetchFolder());
    }
    return updated;
  }

  Future<bool> deleteFolder(int id) {
    var deleted = folderRepository.delete(id);
    if (currentState is FolderLoaded) {
      dispatch(FetchFolder());
    }
    return deleted;
  }
}

abstract class FolderEvent extends Equatable {
  FolderEvent([List props = const []]) : super(props);
}

class FetchFolder extends FolderEvent {}

abstract class FolderState extends Equatable {
  FolderState([List props = const []]) : super(props);
}

class FolderLoading extends FolderState {}

class FolderLoaded extends FolderState {
  final List<Folder> folders;

  FolderLoaded({@required this.folders})
      : assert(folders != null),
        super([folders]);
}
