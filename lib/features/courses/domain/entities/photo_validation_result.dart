import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_validation_result.freezed.dart';

@freezed
class PhotoValidationResult with _$PhotoValidationResult {
  const factory PhotoValidationResult({
    required bool isCorrect,
    required String rawResponse,
  }) = _PhotoValidationResult;
}
