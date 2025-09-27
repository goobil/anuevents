import 'dart:typed_data';
import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'storage_service.dart';

class FirebaseStorageService implements StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  UploadController uploadPoster(String filename, List<int> bytes, {ProgressCallback? onProgress}) {
    final ref = _storage.ref().child('posters').child(filename);
    final uploadTask = ref.putData(Uint8List.fromList(bytes));

    // Bridge snapshot events to progress callback
    final sub = uploadTask.snapshotEvents.listen((snapshot) {
      final total = snapshot.totalBytes;
      final transferred = snapshot.bytesTransferred;
      if (total > 0) {
        final progress = transferred / total;
        try {
          onProgress?.call(progress);
        } catch (_) {}
      }
    });

    final completer = Completer<String>();

    // Wait for the upload task to finish and then complete the completer.
    () async {
      try {
        await uploadTask;
        final url = await ref.getDownloadURL();
        if (!completer.isCompleted) completer.complete(url);
      } catch (e) {
        if (!completer.isCompleted) completer.completeError(e);
      } finally {
        await sub.cancel();
      }
    }();

    // Provide a cancel function that calls the underlying task.cancel
    void cancel() {
      try {
        uploadTask.cancel();
      } catch (_) {}
    }

    return UploadController(future: completer.future, cancel: cancel);
  }
}
