import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_result.freezed.dart';
part 'section_result.g.dart';

@freezed
abstract class SectionResult with _$SectionResult {
  const factory SectionResult({
    required String sectionId,
    required double score,
    required bool passed,
    @Default(0) int attempts,
    DateTime? completedAt,
  }) = _SectionResult;

  factory SectionResult.fromJson(Map<String, dynamic> json) =>
      _$SectionResultFromJson(json);
}
