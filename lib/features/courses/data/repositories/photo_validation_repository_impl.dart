import 'dart:typed_data';

import '../../domain/entities/photo_validation_result.dart';
import '../../domain/repositories/photo_validation_repository.dart';
import '../datasources/gemini_photo_datasource.dart';

class PhotoValidationRepositoryImpl implements PhotoValidationRepository {
  final GeminiPhotoDatasource _datasource;

  PhotoValidationRepositoryImpl(this._datasource);

  @override
  Future<PhotoValidationResult> validatePhoto({
    required Uint8List imageBytes,
    required String mimeType,
    required String photoPrompt,
    required List<String> correctAnswer,
  }) async {
    final rawResponse = await _datasource.validate(
      imageBytes: imageBytes,
      mimeType: mimeType,
      photoPrompt: photoPrompt,
      correctAnswer: correctAnswer,
    );

    final isCorrect = rawResponse.trim().toUpperCase().startsWith('CORRECT');

    return PhotoValidationResult(
      isCorrect: isCorrect,
      rawResponse: rawResponse,
    );
  }
}
