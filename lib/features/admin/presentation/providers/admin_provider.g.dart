// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseEnrollmentsHash() => r'6264acf216d927bdcc9213e847914672557077a0';

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

/// See also [courseEnrollments].
@ProviderFor(courseEnrollments)
const courseEnrollmentsProvider = CourseEnrollmentsFamily();

/// See also [courseEnrollments].
class CourseEnrollmentsFamily extends Family<AsyncValue<List<Enrollment>>> {
  /// See also [courseEnrollments].
  const CourseEnrollmentsFamily();

  /// See also [courseEnrollments].
  CourseEnrollmentsProvider call(String courseId) {
    return CourseEnrollmentsProvider(courseId);
  }

  @override
  CourseEnrollmentsProvider getProviderOverride(
    covariant CourseEnrollmentsProvider provider,
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
  String? get name => r'courseEnrollmentsProvider';
}

/// See also [courseEnrollments].
class CourseEnrollmentsProvider
    extends AutoDisposeFutureProvider<List<Enrollment>> {
  /// See also [courseEnrollments].
  CourseEnrollmentsProvider(String courseId)
    : this._internal(
        (ref) => courseEnrollments(ref as CourseEnrollmentsRef, courseId),
        from: courseEnrollmentsProvider,
        name: r'courseEnrollmentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$courseEnrollmentsHash,
        dependencies: CourseEnrollmentsFamily._dependencies,
        allTransitiveDependencies:
            CourseEnrollmentsFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  CourseEnrollmentsProvider._internal(
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
    FutureOr<List<Enrollment>> Function(CourseEnrollmentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseEnrollmentsProvider._internal(
        (ref) => create(ref as CourseEnrollmentsRef),
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
  AutoDisposeFutureProviderElement<List<Enrollment>> createElement() {
    return _CourseEnrollmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseEnrollmentsProvider && other.courseId == courseId;
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
mixin CourseEnrollmentsRef on AutoDisposeFutureProviderRef<List<Enrollment>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseEnrollmentsProviderElement
    extends AutoDisposeFutureProviderElement<List<Enrollment>>
    with CourseEnrollmentsRef {
  _CourseEnrollmentsProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseEnrollmentsProvider).courseId;
}

String _$userByIdHash() => r'50d94c4bb7123649c97dff9d7f65fa27be6d5f98';

/// See also [userById].
@ProviderFor(userById)
const userByIdProvider = UserByIdFamily();

/// See also [userById].
class UserByIdFamily extends Family<AsyncValue<AppUser?>> {
  /// See also [userById].
  const UserByIdFamily();

  /// See also [userById].
  UserByIdProvider call(String userId) {
    return UserByIdProvider(userId);
  }

  @override
  UserByIdProvider getProviderOverride(covariant UserByIdProvider provider) {
    return call(provider.userId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'userByIdProvider';
}

/// See also [userById].
class UserByIdProvider extends AutoDisposeFutureProvider<AppUser?> {
  /// See also [userById].
  UserByIdProvider(String userId)
    : this._internal(
        (ref) => userById(ref as UserByIdRef, userId),
        from: userByIdProvider,
        name: r'userByIdProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userByIdHash,
        dependencies: UserByIdFamily._dependencies,
        allTransitiveDependencies: UserByIdFamily._allTransitiveDependencies,
        userId: userId,
      );

  UserByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.userId,
  }) : super.internal();

  final String userId;

  @override
  Override overrideWith(
    FutureOr<AppUser?> Function(UserByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserByIdProvider._internal(
        (ref) => create(ref as UserByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        userId: userId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<AppUser?> createElement() {
    return _UserByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserByIdProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UserByIdRef on AutoDisposeFutureProviderRef<AppUser?> {
  /// The parameter `userId` of this provider.
  String get userId;
}

class _UserByIdProviderElement
    extends AutoDisposeFutureProviderElement<AppUser?>
    with UserByIdRef {
  _UserByIdProviderElement(super.provider);

  @override
  String get userId => (origin as UserByIdProvider).userId;
}

String _$adminCourseNotifierHash() =>
    r'1f9c0f9f51e2dbb848cd92d616d91865bd71ee40';

/// See also [AdminCourseNotifier].
@ProviderFor(AdminCourseNotifier)
final adminCourseNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AdminCourseNotifier, void>.internal(
      AdminCourseNotifier.new,
      name: r'adminCourseNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminCourseNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdminCourseNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
