import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageDatasource {
  final FirebaseStorage _storage;

  FirebaseStorageDatasource({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance;

  Reference _profilePhotoRef(String uid) =>
      _storage.ref().child('profile_photos/$uid.jpg');

  Future<String> uploadProfilePhoto(String uid, Uint8List bytes) async {
    final ref = _profilePhotoRef(uid);
    await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
    return ref.getDownloadURL();
  }

  Future<void> deleteProfilePhoto(String uid) async {
    try {
      await _profilePhotoRef(uid).delete();
    } on FirebaseException catch (e) {
      // Ignore "object-not-found" — file may already be deleted
      if (e.code != 'object-not-found') rethrow;
    }
  }
}
