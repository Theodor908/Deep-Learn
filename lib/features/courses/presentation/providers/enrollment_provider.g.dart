// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$enrollmentRepositoryHash() =>
    r'cf69b6d9f95719f7c2bbabc23c2488afbf1c323d';

/// See also [enrollmentRepository].
@ProviderFor(enrollmentRepository)
final enrollmentRepositoryProvider =
    AutoDisposeProvider<EnrollmentRepository>.internal(
      enrollmentRepository,
      name: r'enrollmentRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$enrollmentRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef EnrollmentRepositoryRef = AutoDisposeProviderRef<EnrollmentRepository>;
String _$enrollmentHash() => r'd8f5c10b574895007d732ce4a62a48b2bef2ed66';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [enrollment].
@ProviderFor(enrollment)
const enrollmentProvider = EnrollmentFamily();

/// See also [enrollment].
class EnrollmentFamily extends Family<AsyncValue<Enrollment?>> {
  /// See also [enrollment].
  const EnrollmentFamily();

  /// See also [enrollment].
  EnrollmentProvider call(String courseId) {
    return EnrollmentProvider(courseId);
  }

  @override
  EnrollmentProvider getProviderOverride(
    covariant EnrollmentProvider provider,
  ) {
    return call(provider.courseId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'enrollmentProvider';
}

/// See also [enrollment].
class EnrollmentProvider extends AutoDisposeFutureProvider<Enrollment?> {
  /// See also [enrollment].
  EnrollmentProvider(String courseId)
    : this._internal(
        (ref) => enrollment(ref as EnrollmentRef, courseId),
        from: enrollmentProvider,
        name: r'enrollmentProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$enrollmentHash,
        dependencies: EnrollmentFamily._dependencies,
        allTransitiveDependencies: EnrollmentFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  EnrollmentProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
  }) : super.internal();

  final String courseId;

  @override
  Override overrideWith(
    FutureOr<Enrollment?> Function(EnrollmentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EnrollmentProvider._internal(
        (ref) => create(ref as EnrollmentRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Enrollment?> createElement() {
    return _EnrollmentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EnrollmentProvider && other.courseId == courseId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin EnrollmentRef on AutoDisposeFutureProviderRef<Enrollment?> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _EnrollmentProviderElement
    extends AutoDisposeFutureProviderElement<Enrollment?>
    with EnrollmentRef {
  _EnrollmentProviderElement(super.provider);

  @override
  String get courseId => (origin as EnrollmentProvider).courseId;
}

String _$userEnrollmentsHash() => r'0f64bb60b58eafdd254b07beb3ed8bfdfec025ce';

/// See also [userEnrollments].
@ProviderFor(userEnrollments)
final userEnrollmentsProvider =
    AutoDisposeFutureProvider<List<Enrollment>>.internal(
      userEnrollments,
      name: r'userEnrollmentsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userEnrollmentsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserEnrollmentsRef = AutoDisposeFutureProviderRef<List<Enrollment>>;
String _$recommendedCoursesHash() =>
    r'917015d571bfaa70d364753dd5cb77aa97aabaf9';

/// See also [recommendedCourses].
@ProviderFor(recommendedCourses)
final recommendedCoursesProvider =
    AutoDisposeFutureProvider<List<Course>>.internal(
      recommendedCourses,
      name: r'recommendedCoursesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recommendedCoursesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecommendedCoursesRef = AutoDisposeFutureProviderRef<List<Course>>;
String _$enrollmentNotifierHash() =>
    r'e49d3ac15f66ed15f83a4c93cb0f1791592230e8';

/// See also [EnrollmentNotifier].
@ProviderFor(EnrollmentNotifier)
final enrollmentNotifierProvider =
    AutoDisposeAsyncNotifierProvider<EnrollmentNotifier, void>.internal(
      EnrollmentNotifier.new,
      name: r'enrollmentNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$enrollmentNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$EnrollmentNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
