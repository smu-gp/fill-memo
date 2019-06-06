import 'package:bloc/bloc.dart';

import './add_image_event.dart';
import './add_image_state.dart';

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
