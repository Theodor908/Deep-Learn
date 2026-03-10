// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReviewItemModel _$ReviewItemModelFromJson(Map<String, dynamic> json) {
  return _ReviewItemModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewItemModel {
  String get userId => throw _privateConstructorUsedError;
  String get courseId => throw _privateConstructorUsedError;
  String get sectionId => throw _privateConstructorUsedError;
  DateTime get nextReviewAt => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  double get easeFactor => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;

  /// Serializes this ReviewItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewItemModelCopyWith<ReviewItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewItemModelCopyWith<$Res> {
  factory $ReviewItemModelCopyWith(
    ReviewItemModel value,
    $Res Function(ReviewItemModel) then,
  ) = _$ReviewItemModelCopyWithImpl<$Res, ReviewItemModel>;
  @useResult
  $Res call({
    String userId,
    String courseId,
    String sectionId,
    DateTime nextReviewAt,
    int interval,
    double easeFactor,
    int reviewCount,
  });
}

/// @nodoc
class _$ReviewItemModelCopyWithImpl<$Res, $Val extends ReviewItemModel>
    implements $ReviewItemModelCopyWith<$Res> {
  _$ReviewItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? courseId = null,
    Object? sectionId = null,
    Object? nextReviewAt = null,
    Object? interval = null,
    Object? easeFactor = null,
    Object? reviewCount = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            courseId: null == courseId
                ? _value.courseId
                : courseId // ignore: cast_nullable_to_non_nullable
                      as String,
            sectionId: null == sectionId
                ? _value.sectionId
                : sectionId // ignore: cast_nullable_to_non_nullable
                      as String,
            nextReviewAt: null == nextReviewAt
                ? _value.nextReviewAt
                : nextReviewAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            interval: null == interval
                ? _value.interval
                : interval // ignore: cast_nullable_to_non_nullable
                      as int,
            easeFactor: null == easeFactor
                ? _value.easeFactor
                : easeFactor // ignore: cast_nullable_to_non_nullable
                      as double,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewItemModelImplCopyWith<$Res>
    implements $ReviewItemModelCopyWith<$Res> {
  factory _$$ReviewItemModelImplCopyWith(
    _$ReviewItemModelImpl value,
    $Res Function(_$ReviewItemModelImpl) then,
  ) = __$$ReviewItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String courseId,
    String sectionId,
    DateTime nextReviewAt,
    int interval,
    double easeFactor,
    int reviewCount,
  });
}

/// @nodoc
class __$$ReviewItemModelImplCopyWithImpl<$Res>
    extends _$ReviewItemModelCopyWithImpl<$Res, _$ReviewItemModelImpl>
    implements _$$ReviewItemModelImplCopyWith<$Res> {
  __$$ReviewItemModelImplCopyWithImpl(
    _$ReviewItemModelImpl _value,
    $Res Function(_$ReviewItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReviewItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? courseId = null,
    Object? sectionId = null,
    Object? nextReviewAt = null,
    Object? interval = null,
    Object? easeFactor = null,
    Object? reviewCount = null,
  }) {
    return _then(
      _$ReviewItemModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        sectionId: null == sectionId
            ? _value.sectionId
            : sectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        nextReviewAt: null == nextReviewAt
            ? _value.nextReviewAt
            : nextReviewAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        interval: null == interval
            ? _value.interval
            : interval // ignore: cast_nullable_to_non_nullable
                  as int,
        easeFactor: null == easeFactor
            ? _value.easeFactor
            : easeFactor // ignore: cast_nullable_to_non_nullable
                  as double,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewItemModelImpl extends _ReviewItemModel {
  const _$ReviewItemModelImpl({
    required this.userId,
    required this.courseId,
    required this.sectionId,
    required this.nextReviewAt,
    this.interval = 1,
    this.easeFactor = 2.5,
    this.reviewCount = 0,
  }) : super._();

  factory _$ReviewItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewItemModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String courseId;
  @override
  final String sectionId;
  @override
  final DateTime nextReviewAt;
  @override
  @JsonKey()
  final int interval;
  @override
  @JsonKey()
  final double easeFactor;
  @override
  @JsonKey()
  final int reviewCount;

  @override
  String toString() {
    return 'ReviewItemModel(userId: $userId, courseId: $courseId, sectionId: $sectionId, nextReviewAt: $nextReviewAt, interval: $interval, easeFactor: $easeFactor, reviewCount: $reviewCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewItemModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.nextReviewAt, nextReviewAt) ||
                other.nextReviewAt == nextReviewAt) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    courseId,
    sectionId,
    nextReviewAt,
    interval,
    easeFactor,
    reviewCount,
  );

  /// Create a copy of ReviewItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewItemModelImplCopyWith<_$ReviewItemModelImpl> get copyWith =>
      __$$ReviewItemModelImplCopyWithImpl<_$ReviewItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewItemModelImplToJson(this);
  }
}

abstract class _ReviewItemModel extends ReviewItemModel {
  const factory _ReviewItemModel({
    required final String userId,
    required final String courseId,
    required final String sectionId,
    required final DateTime nextReviewAt,
    final int interval,
    final double easeFactor,
    final int reviewCount,
  }) = _$ReviewItemModelImpl;
  const _ReviewItemModel._() : super._();

  factory _ReviewItemModel.fromJson(Map<String, dynamic> json) =
      _$ReviewItemModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get courseId;
  @override
  String get sectionId;
  @override
  DateTime get nextReviewAt;
  @override
  int get interval;
  @override
  double get easeFactor;
  @override
  int get reviewCount;

  /// Create a copy of ReviewItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewItemModelImplCopyWith<_$ReviewItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
