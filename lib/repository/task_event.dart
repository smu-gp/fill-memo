enum TaskState {
  progress,
  success,
}

class UploadTaskEvent {
  final TaskState state;
  final int bytesTransferred;
  final int totalBytes;
  final String downloadUrl;

  UploadTaskEvent({
    this.state,
    this.bytesTransferred,
    this.totalBytes,
    this.downloadUrl,
  });

  @override
  String toString() {
    return '$runtimeType(state: $state, bytesTransferred: $bytesTransferred, totalBytes: $totalBytes, downloadUrl: $downloadUrl)';
  }
}
