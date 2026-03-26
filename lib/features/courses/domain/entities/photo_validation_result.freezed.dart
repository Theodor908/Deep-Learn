// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo_validation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PhotoValidationResult {
  bool get isCorrect => throw _privateConstructorUsedError;
  String get rawResponse => throw _privateConstructorUsedError;

  /// Create a copy of PhotoValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhotoValidationResultCopyWith<PhotoValidationResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhotoValidationResultCopyWith<$Res> {
  factory $PhotoValidationResultCopyWith(
    PhotoValidationResult value,
    $Res Function(PhotoValidationResult) then,
  ) = _$PhotoValidationResultCopyWithImpl<$Res, PhotoValidationResult>;
  @useResult
  $Res call({bool isCorrect, String rawResponse});
}

/// @nodoc
class _$PhotoValidationResultCopyWithImpl<
  $Res,
  $Val extends PhotoValidationResult
>
    implements $PhotoValidationResultCopyWith<$Res> {
  _$PhotoValidationResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhotoValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isCorrect = null, Object? rawResponse = null}) {
    return _then(
      _value.copyWith(
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            rawResponse: null == rawResponse
                ? _value.rawResponse
                : rawResponse // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhotoValidationResultImplCopyWith<$Res>
    implements $PhotoValidationResultCopyWith<$Res> {
  factory _$$PhotoValidationResultImplCopyWith(
    _$PhotoValidationResultImpl value,
    $Res Function(_$PhotoValidationResultImpl) then,
  ) = __$$PhotoValidationResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isCorrect, String rawResponse});
}

/// @nodoc
class __$$PhotoValidationResultImplCopyWithImpl<$Res>
    extends
        _$PhotoValidationResultCopyWithImpl<$Res, _$PhotoValidationResultImpl>
    implements _$$PhotoValidationResultImplCopyWith<$Res> {
  __$$PhotoValidationResultImplCopyWithImpl(
    _$PhotoValidationResultImpl _value,
    $Res Function(_$PhotoValidationResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhotoValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? isCorrect = null, Object? rawResponse = null}) {
    return _then(
      _$PhotoValidationResultImpl(
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        rawResponse: null == rawResponse
            ? _value.rawResponse
            : rawResponse // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$PhotoValidationResultImpl implements _PhotoValidationResult {
  const _$PhotoValidationResultImpl({
    required this.isCorrect,
    required this.rawResponse,
  });

  @override
  final bool isCorrect;
  @override
  final String rawResponse;

  @override
  String toString() {
    return 'PhotoValidationResult(isCorrect: $isCorrect, rawResponse: $rawResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhotoValidationResultImpl &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.rawResponse, rawResponse) ||
                other.rawResponse == rawResponse));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isCorrect, rawResponse);

  /// Create a copy of PhotoValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhotoValidationResultImplCopyWith<_$PhotoValidationResultImpl>
  get copyWith =>
      __$$PhotoValidationResultImplCopyWithImpl<_$PhotoValidationResultImpl>(
        this,
        _$identity,
      );
}

abstract class _PhotoValidationResult implements PhotoValidationResult {
  const factory _PhotoValidationResult({
    required final bool isCorrect,
    required final String rawResponse,
  }) = _$PhotoValidationResultImpl;

  @override
  bool get isCorrect;
  @override
  String get rawResponse;

  /// Create a copy of PhotoValidationResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhotoValidationResultImplCopyWith<_$PhotoValidationResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}
