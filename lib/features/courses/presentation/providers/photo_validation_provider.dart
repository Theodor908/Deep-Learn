import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/gemini_photo_datasource.dart';
import '../../data/repositories/photo_validation_repository_impl.dart';
import '../../domain/repositories/photo_validation_repository.dart';

part 'photo_validation_provider.g.dart';

@riverpod
PhotoValidationRepository photoValidationRepository(
    PhotoValidationRepositoryRef ref) {
  return PhotoValidationRepositoryImpl(GeminiPhotoDatasource());
}
