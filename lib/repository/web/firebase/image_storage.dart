import 'package:firebase/firebase.dart' as fb;

import '../../task_event.dart';

class ImageStorage {
  static Stream<UploadTaskEvent> putFile({
    String userId,
    String name,
    Object file,
  }) async* {
    var storage = fb.storage();
    var uploadTask = storage.ref(userId).child(name).put(file);

    await for (final event in uploadTask.onStateChanged) {
      if (event.state == fb.TaskState.RUNNING) {
        yield UploadTaskEvent(
          state: TaskState.progress,
          bytesTransferred: event.bytesTransferred,
          totalBytes: event.totalBytes,
        );
      }
    }

    final downloadUrl = await uploadTask.snapshot.ref.getDownloadURL();
    yield UploadTaskEvent(
      state: TaskState.success,
      downloadUrl: downloadUrl.toString(),
    );
  }
}
