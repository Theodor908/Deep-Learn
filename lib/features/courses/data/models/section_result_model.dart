import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/section_result.dart';

part 'section_result_model.freezed.dart';
part 'section_result_model.g.dart';

@freezed
abstract class SectionResultModel with _$SectionResultModel {
  const SectionResultModel._();

  const factory SectionResultModel({
    required String sectionId,
    required double score,
    required bool passed,
    @Default(0) int attempts,
    DateTime? completedAt,
  }) = _SectionResultModel;

  factory SectionResultModel.fromJson(Map<String, dynamic> json) =>
      _$SectionResultModelFromJson(json);

  factory SectionResultModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SectionResultModel.fromJson({
      ...data,
      if (data['completedAt'] != null)
        'completedAt':
            (data['completedAt'] as Timestamp).toDate().toIso8601String(),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    if (completedAt != null) {
      json['completedAt'] = Timestamp.fromDate(completedAt!);
    }
    return json;
  }

  SectionResult toEntity() => SectionResult(
        sectionId: sectionId,
        score: score,
        passed: passed,
        attempts: attempts,
        completedAt: completedAt,
      );

  factory SectionResultModel.fromEntity(SectionResult result) =>
      SectionResultModel(
        sectionId: result.sectionId,
        score: result.score,
        passed: result.passed,
        attempts: result.attempts,
        completedAt: result.completedAt,
      );
}
