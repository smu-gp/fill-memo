import 'package:bloc/bloc.dart';
import 'package:sp_client/bloc/add_image/add_image.dart';
import 'package:sp_client/bloc/blocs.dart';

class AddImageBloc extends Bloc<AddImageEvent, AddImageState> {
  final String initImage;

  AddImageBloc(this.initImage);

  @override
  AddImageState get initialState => ReadyImage(initImage);

  @override
  Stream<AddImageState> mapEventToState(
    AddImageEvent event,
  ) async* {
    if (event is SendImage) {
    } else if (event is StartCrop) {
      yield* _mapStartCropToState();
    } else if (event is SaveCrop) {
      yield* _mapSaveCropToState(event);
    } else if (event is UndoCrop) {
      yield* _mapUndoCropToState();
    }
  }

  Stream<AddImageState> _mapStartCropToState() async* {
    yield CropImage(initImage);
  }

  Stream<AddImageState> _mapSaveCropToState(SaveCrop event) async* {
    yield ReadyImage(initImage, clipRect: event.cropRect);
  }

  Stream<AddImageState> _mapUndoCropToState() async* {
    yield ReadyImage(initImage);
  }
}
