import 'package:fill_memo/repository/task_event.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImageStorage {
  static Stream<UploadTaskEvent> putFile({
    String userId,
    String name,
    Object file,
  }) async* {
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child(userId).child(name);
    final uploadTask = storageRef.putFile(file);

    await for (final event in uploadTask.events) {
      if (event.type == StorageTaskEventType.progress) {
        yield UploadTaskEvent(
          state: TaskState.progress,
          bytesTransferred: event.snapshot.bytesTransferred,
          totalBytes: event.snapshot.totalByteCount,
        );
      } else if (event.type == StorageTaskEventType.success) {
        final downloadUrl = await event.snapshot.ref.getDownloadURL();
        yield UploadTaskEvent(
          state: TaskState.success,
          downloadUrl: downloadUrl,
        );
      }
    }
  }
}
