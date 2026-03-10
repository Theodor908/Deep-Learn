// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'section_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SectionResult _$SectionResultFromJson(Map<String, dynamic> json) {
  return _SectionResult.fromJson(json);
}

/// @nodoc
mixin _$SectionResult {
  String get sectionId => throw _privateConstructorUsedError;
  double get score => throw _privateConstructorUsedError;
  bool get passed => throw _privateConstructorUsedError;
  int get attempts => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Serializes this SectionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SectionResultCopyWith<SectionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SectionResultCopyWith<$Res> {
  factory $SectionResultCopyWith(
    SectionResult value,
    $Res Function(SectionResult) then,
  ) = _$SectionResultCopyWithImpl<$Res, SectionResult>;
  @useResult
  $Res call({
    String sectionId,
    double score,
    bool passed,
    int attempts,
    DateTime? completedAt,
  });
}

/// @nodoc
class _$SectionResultCopyWithImpl<$Res, $Val extends SectionResult>
    implements $SectionResultCopyWith<$Res> {
  _$SectionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionId = null,
    Object? score = null,
    Object? passed = null,
    Object? attempts = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            sectionId: null == sectionId
                ? _value.sectionId
                : sectionId // ignore: cast_nullable_to_non_nullable
                      as String,
            score: null == score
                ? _value.score
                : score // ignore: cast_nullable_to_non_nullable
                      as double,
            passed: null == passed
                ? _value.passed
                : passed // ignore: cast_nullable_to_non_nullable
                      as bool,
            attempts: null == attempts
                ? _value.attempts
                : attempts // ignore: cast_nullable_to_non_nullable
                      as int,
            completedAt: freezed == completedAt
                ? _value.completedAt
                : completedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SectionResultImplCopyWith<$Res>
    implements $SectionResultCopyWith<$Res> {
  factory _$$SectionResultImplCopyWith(
    _$SectionResultImpl value,
    $Res Function(_$SectionResultImpl) then,
  ) = __$$SectionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String sectionId,
    double score,
    bool passed,
    int attempts,
    DateTime? completedAt,
  });
}

/// @nodoc
class __$$SectionResultImplCopyWithImpl<$Res>
    extends _$SectionResultCopyWithImpl<$Res, _$SectionResultImpl>
    implements _$$SectionResultImplCopyWith<$Res> {
  __$$SectionResultImplCopyWithImpl(
    _$SectionResultImpl _value,
    $Res Function(_$SectionResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sectionId = null,
    Object? score = null,
    Object? passed = null,
    Object? attempts = null,
    Object? completedAt = freezed,
  }) {
    return _then(
      _$SectionResultImpl(
        sectionId: null == sectionId
            ? _value.sectionId
            : sectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        score: null == score
            ? _value.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double,
        passed: null == passed
            ? _value.passed
            : passed // ignore: cast_nullable_to_non_nullable
                  as bool,
        attempts: null == attempts
            ? _value.attempts
            : attempts // ignore: cast_nullable_to_non_nullable
                  as int,
        completedAt: freezed == completedAt
            ? _value.completedAt
            : completedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SectionResultImpl implements _SectionResult {
  const _$SectionResultImpl({
    required this.sectionId,
    required this.score,
    required this.passed,
    this.attempts = 0,
    this.completedAt,
  });

  factory _$SectionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SectionResultImplFromJson(json);

  @override
  final String sectionId;
  @override
  final double score;
  @override
  final bool passed;
  @override
  @JsonKey()
  final int attempts;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'SectionResult(sectionId: $sectionId, score: $score, passed: $passed, attempts: $attempts, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SectionResultImpl &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.passed, passed) || other.passed == passed) &&
            (identical(other.attempts, attempts) ||
                other.attempts == attempts) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sectionId, score, passed, attempts, completedAt);

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SectionResultImplCopyWith<_$SectionResultImpl> get copyWith =>
      __$$SectionResultImplCopyWithImpl<_$SectionResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SectionResultImplToJson(this);
  }
}

abstract class _SectionResult implements SectionResult {
  const factory _SectionResult({
    required final String sectionId,
    required final double score,
    required final bool passed,
    final int attempts,
    final DateTime? completedAt,
  }) = _$SectionResultImpl;

  factory _SectionResult.fromJson(Map<String, dynamic> json) =
      _$SectionResultImpl.fromJson;

  @override
  String get sectionId;
  @override
  double get score;
  @override
  bool get passed;
  @override
  int get attempts;
  @override
  DateTime? get completedAt;

  /// Create a copy of SectionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SectionResultImplCopyWith<_$SectionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
