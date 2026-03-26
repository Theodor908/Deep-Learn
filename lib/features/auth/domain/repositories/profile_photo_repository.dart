import 'dart:typed_data';

abstract class ProfilePhotoRepository {
  Future<String> uploadPhoto(String uid, Uint8List bytes);
  Future<void> deletePhoto(String uid);
}
