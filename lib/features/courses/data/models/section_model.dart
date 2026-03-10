import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/section.dart';

part 'section_model.freezed.dart';
part 'section_model.g.dart';

@freezed
abstract class SectionModel with _$SectionModel {
  const SectionModel._();

  const factory SectionModel({
    required String id,
    required String courseId,
    required String title,
    required String summary,
    required int order,
    required String content,
    @Default([]) List<String> imageUrls,
    @Default(false) bool isFreePreview,
  }) = _SectionModel;

  factory SectionModel.fromJson(Map<String, dynamic> json) =>
      _$SectionModelFromJson(json);

  factory SectionModel.fromFirestore(DocumentSnapshot doc, String courseId) {
    final data = doc.data() as Map<String, dynamic>;
    return SectionModel.fromJson({
      'id': doc.id,
      'courseId': courseId,
      ...data,
      'imageUrls': List<String>.from(data['imageUrls'] ?? []),
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    json.remove('courseId');
    return json;
  }

  Section toEntity() => Section(
        id: id,
        courseId: courseId,
        title: title,
        summary: summary,
        order: order,
        content: content,
        imageUrls: imageUrls,
        isFreePreview: isFreePreview,
      );

  factory SectionModel.fromEntity(Section section) => SectionModel(
        id: section.id,
        courseId: section.courseId,
        title: section.title,
        summary: section.summary,
        order: section.order,
        content: section.content,
        imageUrls: section.imageUrls,
        isFreePreview: section.isFreePreview,
      );
}
