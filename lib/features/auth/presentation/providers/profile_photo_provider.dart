import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/firebase_storage_datasource.dart';
import '../../data/repositories/profile_photo_repository_impl.dart';
import '../../domain/repositories/profile_photo_repository.dart';
import 'auth_provider.dart';

part 'profile_photo_provider.g.dart';

@riverpod
ProfilePhotoRepository profilePhotoRepository(ProfilePhotoRepositoryRef ref) {
  return ProfilePhotoRepositoryImpl(FirebaseStorageDatasource());
}

@riverpod
class ProfilePhotoNotifier extends _$ProfilePhotoNotifier {
  @override
  FutureOr<void> build() {
    // idle state
  }

  Future<void> uploadPhoto(ImageSource source) async {
    final authRepo = ref.read(authRepositoryProvider);
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (image == null) return; // user cancelled

      final bytes = await image.readAsBytes();
      if (bytes.lengthInBytes > 2 * 1024 * 1024) {
        throw Exception('Image is too large. Please try a different photo.');
      }

      final photoRepo = ref.read(profilePhotoRepositoryProvider);
      final downloadUrl = await photoRepo.uploadPhoto(user.uid, bytes);
      await authRepo.updateProfile(photoUrl: downloadUrl);

      ref.invalidate(authStateProvider);
      ref.invalidate(authNotifierProvider);
    });
  }

  Future<void> removePhoto() async {
    final authRepo = ref.read(authRepositoryProvider);
    final user = ref.read(authStateProvider).valueOrNull;
    if (user == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final photoRepo = ref.read(profilePhotoRepositoryProvider);
      await photoRepo.deletePhoto(user.uid);
      await authRepo.updateProfile(clearPhoto: true);

      ref.invalidate(authStateProvider);
      ref.invalidate(authNotifierProvider);
    });
  }
}
