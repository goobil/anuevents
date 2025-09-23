import 'dart:async';

typedef ProgressCallback = void Function(double percent);

/// A controller returned when starting an upload. The [future] completes
/// with the uploaded file URL (or completes with an error). Call [cancel]
/// to abort an in-flight upload.
class UploadController {
  UploadController({required this.future, required this.cancel});

  final Future<String> future;
  final void Function() cancel;
}

abstract class StorageService {
  /// Starts uploading poster bytes and returns an [UploadController]. An
  /// optional [onProgress] callback receives values between 0.0 and 1.0.
  UploadController uploadPoster(String filename, List<int> bytes, {ProgressCallback? onProgress});
}

class MockStorageService implements StorageService {
  @override
  UploadController uploadPoster(String filename, List<int> bytes, {ProgressCallback? onProgress}) {
    final canceled = <bool>[false];
    final completer = Completer<String>();

    // Simulate upload progress asynchronously
    () async {
      const steps = 10;
      for (var i = 1; i <= steps; i++) {
        if (canceled[0]) {
          completer.completeError(Exception('upload cancelled'));
          return;
        }
        await Future.delayed(const Duration(milliseconds: 80));
        onProgress?.call(i / steps);
      }
      if (!completer.isCompleted) {
        completer.complete('https://example.com/$filename');
      }
    }();

    return UploadController(
      future: completer.future,
      cancel: () { canceled[0] = true; },
    );
  }
}
