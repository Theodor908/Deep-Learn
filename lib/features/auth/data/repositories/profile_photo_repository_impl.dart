import 'dart:typed_data';

import '../../domain/repositories/profile_photo_repository.dart';
import '../datasources/firebase_storage_datasource.dart';

class ProfilePhotoRepositoryImpl implements ProfilePhotoRepository {
  final FirebaseStorageDatasource _datasource;

  ProfilePhotoRepositoryImpl(this._datasource);

  @override
  Future<String> uploadPhoto(String uid, Uint8List bytes) {
    return _datasource.uploadProfilePhoto(uid, bytes);
  }

  @override
  Future<void> deletePhoto(String uid) {
    return _datasource.deleteProfilePhoto(uid);
  }
}
