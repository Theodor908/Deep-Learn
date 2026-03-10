// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewRepositoryHash() => r'067d237d41890d4c77c83cfa79a32946129e03e9';

/// See also [reviewRepository].
@ProviderFor(reviewRepository)
final reviewRepositoryProvider = AutoDisposeProvider<ReviewRepository>.internal(
  reviewRepository,
  name: r'reviewRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reviewRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReviewRepositoryRef = AutoDisposeProviderRef<ReviewRepository>;
String _$courseReviewsHash() => r'30ea5213205e7d0116bda4cd23532ac3ff9688dc';

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

/// See also [courseReviews].
@ProviderFor(courseReviews)
const courseReviewsProvider = CourseReviewsFamily();

/// See also [courseReviews].
class CourseReviewsFamily extends Family<AsyncValue<List<Review>>> {
  /// See also [courseReviews].
  const CourseReviewsFamily();

  /// See also [courseReviews].
  CourseReviewsProvider call(String courseId) {
    return CourseReviewsProvider(courseId);
  }

  @override
  CourseReviewsProvider getProviderOverride(
    covariant CourseReviewsProvider provider,
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
  String? get name => r'courseReviewsProvider';
}

/// See also [courseReviews].
class CourseReviewsProvider extends AutoDisposeFutureProvider<List<Review>> {
  /// See also [courseReviews].
  CourseReviewsProvider(String courseId)
    : this._internal(
        (ref) => courseReviews(ref as CourseReviewsRef, courseId),
        from: courseReviewsProvider,
        name: r'courseReviewsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$courseReviewsHash,
        dependencies: CourseReviewsFamily._dependencies,
        allTransitiveDependencies:
            CourseReviewsFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  CourseReviewsProvider._internal(
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
    FutureOr<List<Review>> Function(CourseReviewsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseReviewsProvider._internal(
        (ref) => create(ref as CourseReviewsRef),
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
  AutoDisposeFutureProviderElement<List<Review>> createElement() {
    return _CourseReviewsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseReviewsProvider && other.courseId == courseId;
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
mixin CourseReviewsRef on AutoDisposeFutureProviderRef<List<Review>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseReviewsProviderElement
    extends AutoDisposeFutureProviderElement<List<Review>>
    with CourseReviewsRef {
  _CourseReviewsProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseReviewsProvider).courseId;
}

String _$userReviewHash() => r'c9c11f1f08353a330e34797e032f6325fdefe92d';

/// See also [userReview].
@ProviderFor(userReview)
const userReviewProvider = UserReviewFamily();

/// See also [userReview].
class UserReviewFamily extends Family<AsyncValue<Review?>> {
  /// See also [userReview].
  const UserReviewFamily();

  /// See also [userReview].
  UserReviewProvider call(String courseId) {
    return UserReviewProvider(courseId);
  }

  @override
  UserReviewProvider getProviderOverride(
    covariant UserReviewProvider provider,
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
  String? get name => r'userReviewProvider';
}

/// See also [userReview].
class UserReviewProvider extends AutoDisposeFutureProvider<Review?> {
  /// See also [userReview].
  UserReviewProvider(String courseId)
    : this._internal(
        (ref) => userReview(ref as UserReviewRef, courseId),
        from: userReviewProvider,
        name: r'userReviewProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$userReviewHash,
        dependencies: UserReviewFamily._dependencies,
        allTransitiveDependencies: UserReviewFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  UserReviewProvider._internal(
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
    FutureOr<Review?> Function(UserReviewRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: UserReviewProvider._internal(
        (ref) => create(ref as UserReviewRef),
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
  AutoDisposeFutureProviderElement<Review?> createElement() {
    return _UserReviewProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UserReviewProvider && other.courseId == courseId;
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
mixin UserReviewRef on AutoDisposeFutureProviderRef<Review?> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _UserReviewProviderElement
    extends AutoDisposeFutureProviderElement<Review?>
    with UserReviewRef {
  _UserReviewProviderElement(super.provider);

  @override
  String get courseId => (origin as UserReviewProvider).courseId;
}

String _$reviewNotifierHash() => r'a5beb48396729524490c5b2349788fe5b90c4cf6';

/// See also [ReviewNotifier].
@ProviderFor(ReviewNotifier)
final reviewNotifierProvider =
    AutoDisposeAsyncNotifierProvider<ReviewNotifier, void>.internal(
      ReviewNotifier.new,
      name: r'reviewNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reviewNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReviewNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
