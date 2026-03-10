// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SectionImpl _$$SectionImplFromJson(Map<String, dynamic> json) =>
    _$SectionImpl(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      order: (json['order'] as num).toInt(),
      content: json['content'] as String,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      isFreePreview: json['isFreePreview'] as bool? ?? false,
    );

Map<String, dynamic> _$$SectionImplToJson(_$SectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courseId': instance.courseId,
      'title': instance.title,
      'summary': instance.summary,
      'order': instance.order,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'isFreePreview': instance.isFreePreview,
    };
