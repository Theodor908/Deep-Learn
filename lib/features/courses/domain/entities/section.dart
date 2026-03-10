import 'package:freezed_annotation/freezed_annotation.dart';

part 'section.freezed.dart';
part 'section.g.dart';

@freezed
abstract class Section with _$Section {
  const factory Section({
    required String id,
    required String courseId,
    required String title,
    required String summary,
    required int order,
    required String content,
    @Default([]) List<String> imageUrls,
    @Default(false) bool isFreePreview,
  }) = _Section;

  factory Section.fromJson(Map<String, dynamic> json) =>
      _$SectionFromJson(json);
}
