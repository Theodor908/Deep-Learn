// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enrollment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

EnrollmentModel _$EnrollmentModelFromJson(Map<String, dynamic> json) {
  return _EnrollmentModel.fromJson(json);
}

/// @nodoc
mixin _$EnrollmentModel {
  String get userId => throw _privateConstructorUsedError;
  String get courseId => throw _privateConstructorUsedError;
  DateTime get enrolledAt => throw _privateConstructorUsedError;
  DateTime get lastAccessedAt => throw _privateConstructorUsedError;
  int get currentSectionOrder => throw _privateConstructorUsedError;
  List<int> get completedSections => throw _privateConstructorUsedError;
  double get completionPercentage => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;

  /// Serializes this EnrollmentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnrollmentModelCopyWith<EnrollmentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnrollmentModelCopyWith<$Res> {
  factory $EnrollmentModelCopyWith(
    EnrollmentModel value,
    $Res Function(EnrollmentModel) then,
  ) = _$EnrollmentModelCopyWithImpl<$Res, EnrollmentModel>;
  @useResult
  $Res call({
    String userId,
    String courseId,
    DateTime enrolledAt,
    DateTime lastAccessedAt,
    int currentSectionOrder,
    List<int> completedSections,
    double completionPercentage,
    int rating,
  });
}

/// @nodoc
class _$EnrollmentModelCopyWithImpl<$Res, $Val extends EnrollmentModel>
    implements $EnrollmentModelCopyWith<$Res> {
  _$EnrollmentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? courseId = null,
    Object? enrolledAt = null,
    Object? lastAccessedAt = null,
    Object? currentSectionOrder = null,
    Object? completedSections = null,
    Object? completionPercentage = null,
    Object? rating = null,
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
            enrolledAt: null == enrolledAt
                ? _value.enrolledAt
                : enrolledAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastAccessedAt: null == lastAccessedAt
                ? _value.lastAccessedAt
                : lastAccessedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            currentSectionOrder: null == currentSectionOrder
                ? _value.currentSectionOrder
                : currentSectionOrder // ignore: cast_nullable_to_non_nullable
                      as int,
            completedSections: null == completedSections
                ? _value.completedSections
                : completedSections // ignore: cast_nullable_to_non_nullable
                      as List<int>,
            completionPercentage: null == completionPercentage
                ? _value.completionPercentage
                : completionPercentage // ignore: cast_nullable_to_non_nullable
                      as double,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnrollmentModelImplCopyWith<$Res>
    implements $EnrollmentModelCopyWith<$Res> {
  factory _$$EnrollmentModelImplCopyWith(
    _$EnrollmentModelImpl value,
    $Res Function(_$EnrollmentModelImpl) then,
  ) = __$$EnrollmentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String courseId,
    DateTime enrolledAt,
    DateTime lastAccessedAt,
    int currentSectionOrder,
    List<int> completedSections,
    double completionPercentage,
    int rating,
  });
}

/// @nodoc
class __$$EnrollmentModelImplCopyWithImpl<$Res>
    extends _$EnrollmentModelCopyWithImpl<$Res, _$EnrollmentModelImpl>
    implements _$$EnrollmentModelImplCopyWith<$Res> {
  __$$EnrollmentModelImplCopyWithImpl(
    _$EnrollmentModelImpl _value,
    $Res Function(_$EnrollmentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? courseId = null,
    Object? enrolledAt = null,
    Object? lastAccessedAt = null,
    Object? currentSectionOrder = null,
    Object? completedSections = null,
    Object? completionPercentage = null,
    Object? rating = null,
  }) {
    return _then(
      _$EnrollmentModelImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        courseId: null == courseId
            ? _value.courseId
            : courseId // ignore: cast_nullable_to_non_nullable
                  as String,
        enrolledAt: null == enrolledAt
            ? _value.enrolledAt
            : enrolledAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastAccessedAt: null == lastAccessedAt
            ? _value.lastAccessedAt
            : lastAccessedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        currentSectionOrder: null == currentSectionOrder
            ? _value.currentSectionOrder
            : currentSectionOrder // ignore: cast_nullable_to_non_nullable
                  as int,
        completedSections: null == completedSections
            ? _value._completedSections
            : completedSections // ignore: cast_nullable_to_non_nullable
                  as List<int>,
        completionPercentage: null == completionPercentage
            ? _value.completionPercentage
            : completionPercentage // ignore: cast_nullable_to_non_nullable
                  as double,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnrollmentModelImpl extends _EnrollmentModel {
  const _$EnrollmentModelImpl({
    required this.userId,
    required this.courseId,
    required this.enrolledAt,
    required this.lastAccessedAt,
    this.currentSectionOrder = 1,
    final List<int> completedSections = const [],
    this.completionPercentage = 0.0,
    this.rating = 0,
  }) : _completedSections = completedSections,
       super._();

  factory _$EnrollmentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnrollmentModelImplFromJson(json);

  @override
  final String userId;
  @override
  final String courseId;
  @override
  final DateTime enrolledAt;
  @override
  final DateTime lastAccessedAt;
  @override
  @JsonKey()
  final int currentSectionOrder;
  final List<int> _completedSections;
  @override
  @JsonKey()
  List<int> get completedSections {
    if (_completedSections is EqualUnmodifiableListView)
      return _completedSections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedSections);
  }

  @override
  @JsonKey()
  final double completionPercentage;
  @override
  @JsonKey()
  final int rating;

  @override
  String toString() {
    return 'EnrollmentModel(userId: $userId, courseId: $courseId, enrolledAt: $enrolledAt, lastAccessedAt: $lastAccessedAt, currentSectionOrder: $currentSectionOrder, completedSections: $completedSections, completionPercentage: $completionPercentage, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnrollmentModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.courseId, courseId) ||
                other.courseId == courseId) &&
            (identical(other.enrolledAt, enrolledAt) ||
                other.enrolledAt == enrolledAt) &&
            (identical(other.lastAccessedAt, lastAccessedAt) ||
                other.lastAccessedAt == lastAccessedAt) &&
            (identical(other.currentSectionOrder, currentSectionOrder) ||
                other.currentSectionOrder == currentSectionOrder) &&
            const DeepCollectionEquality().equals(
              other._completedSections,
              _completedSections,
            ) &&
            (identical(other.completionPercentage, completionPercentage) ||
                other.completionPercentage == completionPercentage) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    courseId,
    enrolledAt,
    lastAccessedAt,
    currentSectionOrder,
    const DeepCollectionEquality().hash(_completedSections),
    completionPercentage,
    rating,
  );

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnrollmentModelImplCopyWith<_$EnrollmentModelImpl> get copyWith =>
      __$$EnrollmentModelImplCopyWithImpl<_$EnrollmentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EnrollmentModelImplToJson(this);
  }
}

abstract class _EnrollmentModel extends EnrollmentModel {
  const factory _EnrollmentModel({
    required final String userId,
    required final String courseId,
    required final DateTime enrolledAt,
    required final DateTime lastAccessedAt,
    final int currentSectionOrder,
    final List<int> completedSections,
    final double completionPercentage,
    final int rating,
  }) = _$EnrollmentModelImpl;
  const _EnrollmentModel._() : super._();

  factory _EnrollmentModel.fromJson(Map<String, dynamic> json) =
      _$EnrollmentModelImpl.fromJson;

  @override
  String get userId;
  @override
  String get courseId;
  @override
  DateTime get enrolledAt;
  @override
  DateTime get lastAccessedAt;
  @override
  int get currentSectionOrder;
  @override
  List<int> get completedSections;
  @override
  double get completionPercentage;
  @override
  int get rating;

  /// Create a copy of EnrollmentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnrollmentModelImplCopyWith<_$EnrollmentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
