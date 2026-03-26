// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ExerciseModel _$ExerciseModelFromJson(Map<String, dynamic> json) {
  return _ExerciseModel.fromJson(json);
}

/// @nodoc
mixin _$ExerciseModel {
  String get id => throw _privateConstructorUsedError;
  String get sectionId => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError;
  List<String> get options => throw _privateConstructorUsedError;
  List<String> get correctAnswer => throw _privateConstructorUsedError;
  int get order => throw _privateConstructorUsedError;
  String? get explanation => throw _privateConstructorUsedError;
  String? get photoPrompt => throw _privateConstructorUsedError;
  int get retryCooldownSeconds => throw _privateConstructorUsedError;
  double? get destinationLat => throw _privateConstructorUsedError;
  double? get destinationLng => throw _privateConstructorUsedError;
  int get geofenceRadiusMeters => throw _privateConstructorUsedError;

  /// Serializes this ExerciseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseModelCopyWith<ExerciseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseModelCopyWith<$Res> {
  factory $ExerciseModelCopyWith(
    ExerciseModel value,
    $Res Function(ExerciseModel) then,
  ) = _$ExerciseModelCopyWithImpl<$Res, ExerciseModel>;
  @useResult
  $Res call({
    String id,
    String sectionId,
    String type,
    String question,
    List<String> options,
    List<String> correctAnswer,
    int order,
    String? explanation,
    String? photoPrompt,
    int retryCooldownSeconds,
    double? destinationLat,
    double? destinationLng,
    int geofenceRadiusMeters,
  });
}

/// @nodoc
class _$ExerciseModelCopyWithImpl<$Res, $Val extends ExerciseModel>
    implements $ExerciseModelCopyWith<$Res> {
  _$ExerciseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionId = null,
    Object? type = null,
    Object? question = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? order = null,
    Object? explanation = freezed,
    Object? photoPrompt = freezed,
    Object? retryCooldownSeconds = null,
    Object? destinationLat = freezed,
    Object? destinationLng = freezed,
    Object? geofenceRadiusMeters = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            sectionId: null == sectionId
                ? _value.sectionId
                : sectionId // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            question: null == question
                ? _value.question
                : question // ignore: cast_nullable_to_non_nullable
                      as String,
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            correctAnswer: null == correctAnswer
                ? _value.correctAnswer
                : correctAnswer // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            order: null == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as int,
            explanation: freezed == explanation
                ? _value.explanation
                : explanation // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoPrompt: freezed == photoPrompt
                ? _value.photoPrompt
                : photoPrompt // ignore: cast_nullable_to_non_nullable
                      as String?,
            retryCooldownSeconds: null == retryCooldownSeconds
                ? _value.retryCooldownSeconds
                : retryCooldownSeconds // ignore: cast_nullable_to_non_nullable
                      as int,
            destinationLat: freezed == destinationLat
                ? _value.destinationLat
                : destinationLat // ignore: cast_nullable_to_non_nullable
                      as double?,
            destinationLng: freezed == destinationLng
                ? _value.destinationLng
                : destinationLng // ignore: cast_nullable_to_non_nullable
                      as double?,
            geofenceRadiusMeters: null == geofenceRadiusMeters
                ? _value.geofenceRadiusMeters
                : geofenceRadiusMeters // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExerciseModelImplCopyWith<$Res>
    implements $ExerciseModelCopyWith<$Res> {
  factory _$$ExerciseModelImplCopyWith(
    _$ExerciseModelImpl value,
    $Res Function(_$ExerciseModelImpl) then,
  ) = __$$ExerciseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String sectionId,
    String type,
    String question,
    List<String> options,
    List<String> correctAnswer,
    int order,
    String? explanation,
    String? photoPrompt,
    int retryCooldownSeconds,
    double? destinationLat,
    double? destinationLng,
    int geofenceRadiusMeters,
  });
}

/// @nodoc
class __$$ExerciseModelImplCopyWithImpl<$Res>
    extends _$ExerciseModelCopyWithImpl<$Res, _$ExerciseModelImpl>
    implements _$$ExerciseModelImplCopyWith<$Res> {
  __$$ExerciseModelImplCopyWithImpl(
    _$ExerciseModelImpl _value,
    $Res Function(_$ExerciseModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sectionId = null,
    Object? type = null,
    Object? question = null,
    Object? options = null,
    Object? correctAnswer = null,
    Object? order = null,
    Object? explanation = freezed,
    Object? photoPrompt = freezed,
    Object? retryCooldownSeconds = null,
    Object? destinationLat = freezed,
    Object? destinationLng = freezed,
    Object? geofenceRadiusMeters = null,
  }) {
    return _then(
      _$ExerciseModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        sectionId: null == sectionId
            ? _value.sectionId
            : sectionId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        question: null == question
            ? _value.question
            : question // ignore: cast_nullable_to_non_nullable
                  as String,
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        correctAnswer: null == correctAnswer
            ? _value._correctAnswer
            : correctAnswer // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        order: null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as int,
        explanation: freezed == explanation
            ? _value.explanation
            : explanation // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoPrompt: freezed == photoPrompt
            ? _value.photoPrompt
            : photoPrompt // ignore: cast_nullable_to_non_nullable
                  as String?,
        retryCooldownSeconds: null == retryCooldownSeconds
            ? _value.retryCooldownSeconds
            : retryCooldownSeconds // ignore: cast_nullable_to_non_nullable
                  as int,
        destinationLat: freezed == destinationLat
            ? _value.destinationLat
            : destinationLat // ignore: cast_nullable_to_non_nullable
                  as double?,
        destinationLng: freezed == destinationLng
            ? _value.destinationLng
            : destinationLng // ignore: cast_nullable_to_non_nullable
                  as double?,
        geofenceRadiusMeters: null == geofenceRadiusMeters
            ? _value.geofenceRadiusMeters
            : geofenceRadiusMeters // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseModelImpl extends _ExerciseModel {
  const _$ExerciseModelImpl({
    required this.id,
    required this.sectionId,
    required this.type,
    required this.question,
    final List<String> options = const [],
    required final List<String> correctAnswer,
    required this.order,
    this.explanation,
    this.photoPrompt,
    this.retryCooldownSeconds = 60,
    this.destinationLat,
    this.destinationLng,
    this.geofenceRadiusMeters = 100,
  }) : _options = options,
       _correctAnswer = correctAnswer,
       super._();

  factory _$ExerciseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseModelImplFromJson(json);

  @override
  final String id;
  @override
  final String sectionId;
  @override
  final String type;
  @override
  final String question;
  final List<String> _options;
  @override
  @JsonKey()
  List<String> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  final List<String> _correctAnswer;
  @override
  List<String> get correctAnswer {
    if (_correctAnswer is EqualUnmodifiableListView) return _correctAnswer;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_correctAnswer);
  }

  @override
  final int order;
  @override
  final String? explanation;
  @override
  final String? photoPrompt;
  @override
  @JsonKey()
  final int retryCooldownSeconds;
  @override
  final double? destinationLat;
  @override
  final double? destinationLng;
  @override
  @JsonKey()
  final int geofenceRadiusMeters;

  @override
  String toString() {
    return 'ExerciseModel(id: $id, sectionId: $sectionId, type: $type, question: $question, options: $options, correctAnswer: $correctAnswer, order: $order, explanation: $explanation, photoPrompt: $photoPrompt, retryCooldownSeconds: $retryCooldownSeconds, destinationLat: $destinationLat, destinationLng: $destinationLng, geofenceRadiusMeters: $geofenceRadiusMeters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sectionId, sectionId) ||
                other.sectionId == sectionId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality().equals(
              other._correctAnswer,
              _correctAnswer,
            ) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.photoPrompt, photoPrompt) ||
                other.photoPrompt == photoPrompt) &&
            (identical(other.retryCooldownSeconds, retryCooldownSeconds) ||
                other.retryCooldownSeconds == retryCooldownSeconds) &&
            (identical(other.destinationLat, destinationLat) ||
                other.destinationLat == destinationLat) &&
            (identical(other.destinationLng, destinationLng) ||
                other.destinationLng == destinationLng) &&
            (identical(other.geofenceRadiusMeters, geofenceRadiusMeters) ||
                other.geofenceRadiusMeters == geofenceRadiusMeters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    sectionId,
    type,
    question,
    const DeepCollectionEquality().hash(_options),
    const DeepCollectionEquality().hash(_correctAnswer),
    order,
    explanation,
    photoPrompt,
    retryCooldownSeconds,
    destinationLat,
    destinationLng,
    geofenceRadiusMeters,
  );

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseModelImplCopyWith<_$ExerciseModelImpl> get copyWith =>
      __$$ExerciseModelImplCopyWithImpl<_$ExerciseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseModelImplToJson(this);
  }
}

abstract class _ExerciseModel extends ExerciseModel {
  const factory _ExerciseModel({
    required final String id,
    required final String sectionId,
    required final String type,
    required final String question,
    final List<String> options,
    required final List<String> correctAnswer,
    required final int order,
    final String? explanation,
    final String? photoPrompt,
    final int retryCooldownSeconds,
    final double? destinationLat,
    final double? destinationLng,
    final int geofenceRadiusMeters,
  }) = _$ExerciseModelImpl;
  const _ExerciseModel._() : super._();

  factory _ExerciseModel.fromJson(Map<String, dynamic> json) =
      _$ExerciseModelImpl.fromJson;

  @override
  String get id;
  @override
  String get sectionId;
  @override
  String get type;
  @override
  String get question;
  @override
  List<String> get options;
  @override
  List<String> get correctAnswer;
  @override
  int get order;
  @override
  String? get explanation;
  @override
  String? get photoPrompt;
  @override
  int get retryCooldownSeconds;
  @override
  double? get destinationLat;
  @override
  double? get destinationLng;
  @override
  int get geofenceRadiusMeters;

  /// Create a copy of ExerciseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseModelImplCopyWith<_$ExerciseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
