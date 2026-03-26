import 'dart:typed_data';

import '../entities/photo_validation_result.dart';

abstract class PhotoValidationRepository {
  Future<PhotoValidationResult> validatePhoto({
    required Uint8List imageBytes,
    required String mimeType,
    required String photoPrompt,
    required List<String> correctAnswer,
  });
}
