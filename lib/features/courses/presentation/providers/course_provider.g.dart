// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$courseRepositoryHash() => r'f0fd79f83c53b09de81d7ab3f24457241bf23e15';

/// See also [courseRepository].
@ProviderFor(courseRepository)
final courseRepositoryProvider = AutoDisposeProvider<CourseRepository>.internal(
  courseRepository,
  name: r'courseRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$courseRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CourseRepositoryRef = AutoDisposeProviderRef<CourseRepository>;
String _$courseDetailHash() => r'23a97f3ab07d6651a3f26ae33b9878d0a30f2992';

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

/// See also [courseDetail].
@ProviderFor(courseDetail)
const courseDetailProvider = CourseDetailFamily();

/// See also [courseDetail].
class CourseDetailFamily extends Family<AsyncValue<Course>> {
  /// See also [courseDetail].
  const CourseDetailFamily();

  /// See also [courseDetail].
  CourseDetailProvider call(String courseId) {
    return CourseDetailProvider(courseId);
  }

  @override
  CourseDetailProvider getProviderOverride(
    covariant CourseDetailProvider provider,
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
  String? get name => r'courseDetailProvider';
}

/// See also [courseDetail].
class CourseDetailProvider extends AutoDisposeFutureProvider<Course> {
  /// See also [courseDetail].
  CourseDetailProvider(String courseId)
    : this._internal(
        (ref) => courseDetail(ref as CourseDetailRef, courseId),
        from: courseDetailProvider,
        name: r'courseDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$courseDetailHash,
        dependencies: CourseDetailFamily._dependencies,
        allTransitiveDependencies:
            CourseDetailFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  CourseDetailProvider._internal(
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
    FutureOr<Course> Function(CourseDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseDetailProvider._internal(
        (ref) => create(ref as CourseDetailRef),
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
  AutoDisposeFutureProviderElement<Course> createElement() {
    return _CourseDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseDetailProvider && other.courseId == courseId;
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
mixin CourseDetailRef on AutoDisposeFutureProviderRef<Course> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseDetailProviderElement
    extends AutoDisposeFutureProviderElement<Course>
    with CourseDetailRef {
  _CourseDetailProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseDetailProvider).courseId;
}

String _$courseSectionsHash() => r'85aa78208a4fcf34f61b13c2b6434dc33f73416b';

/// See also [courseSections].
@ProviderFor(courseSections)
const courseSectionsProvider = CourseSectionsFamily();

/// See also [courseSections].
class CourseSectionsFamily extends Family<AsyncValue<List<Section>>> {
  /// See also [courseSections].
  const CourseSectionsFamily();

  /// See also [courseSections].
  CourseSectionsProvider call(String courseId) {
    return CourseSectionsProvider(courseId);
  }

  @override
  CourseSectionsProvider getProviderOverride(
    covariant CourseSectionsProvider provider,
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
  String? get name => r'courseSectionsProvider';
}

/// See also [courseSections].
class CourseSectionsProvider extends AutoDisposeFutureProvider<List<Section>> {
  /// See also [courseSections].
  CourseSectionsProvider(String courseId)
    : this._internal(
        (ref) => courseSections(ref as CourseSectionsRef, courseId),
        from: courseSectionsProvider,
        name: r'courseSectionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$courseSectionsHash,
        dependencies: CourseSectionsFamily._dependencies,
        allTransitiveDependencies:
            CourseSectionsFamily._allTransitiveDependencies,
        courseId: courseId,
      );

  CourseSectionsProvider._internal(
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
    FutureOr<List<Section>> Function(CourseSectionsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CourseSectionsProvider._internal(
        (ref) => create(ref as CourseSectionsRef),
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
  AutoDisposeFutureProviderElement<List<Section>> createElement() {
    return _CourseSectionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CourseSectionsProvider && other.courseId == courseId;
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
mixin CourseSectionsRef on AutoDisposeFutureProviderRef<List<Section>> {
  /// The parameter `courseId` of this provider.
  String get courseId;
}

class _CourseSectionsProviderElement
    extends AutoDisposeFutureProviderElement<List<Section>>
    with CourseSectionsRef {
  _CourseSectionsProviderElement(super.provider);

  @override
  String get courseId => (origin as CourseSectionsProvider).courseId;
}

String _$sectionExercisesHash() => r'ebfd0a461c5cd02df32c65f55e9ed25d9ebc1a04';

/// See also [sectionExercises].
@ProviderFor(sectionExercises)
const sectionExercisesProvider = SectionExercisesFamily();

/// See also [sectionExercises].
class SectionExercisesFamily extends Family<AsyncValue<List<Exercise>>> {
  /// See also [sectionExercises].
  const SectionExercisesFamily();

  /// See also [sectionExercises].
  SectionExercisesProvider call(String courseId, String sectionId) {
    return SectionExercisesProvider(courseId, sectionId);
  }

  @override
  SectionExercisesProvider getProviderOverride(
    covariant SectionExercisesProvider provider,
  ) {
    return call(provider.courseId, provider.sectionId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sectionExercisesProvider';
}

/// See also [sectionExercises].
class SectionExercisesProvider
    extends AutoDisposeFutureProvider<List<Exercise>> {
  /// See also [sectionExercises].
  SectionExercisesProvider(String courseId, String sectionId)
    : this._internal(
        (ref) =>
            sectionExercises(ref as SectionExercisesRef, courseId, sectionId),
        from: sectionExercisesProvider,
        name: r'sectionExercisesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sectionExercisesHash,
        dependencies: SectionExercisesFamily._dependencies,
        allTransitiveDependencies:
            SectionExercisesFamily._allTransitiveDependencies,
        courseId: courseId,
        sectionId: sectionId,
      );

  SectionExercisesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.courseId,
    required this.sectionId,
  }) : super.internal();

  final String courseId;
  final String sectionId;

  @override
  Override overrideWith(
    FutureOr<List<Exercise>> Function(SectionExercisesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SectionExercisesProvider._internal(
        (ref) => create(ref as SectionExercisesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        courseId: courseId,
        sectionId: sectionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Exercise>> createElement() {
    return _SectionExercisesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SectionExercisesProvider &&
        other.courseId == courseId &&
        other.sectionId == sectionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, courseId.hashCode);
    hash = _SystemHash.combine(hash, sectionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SectionExercisesRef on AutoDisposeFutureProviderRef<List<Exercise>> {
  /// The parameter `courseId` of this provider.
  String get courseId;

  /// The parameter `sectionId` of this provider.
  String get sectionId;
}

class _SectionExercisesProviderElement
    extends AutoDisposeFutureProviderElement<List<Exercise>>
    with SectionExercisesRef {
  _SectionExercisesProviderElement(super.provider);

  @override
  String get courseId => (origin as SectionExercisesProvider).courseId;
  @override
  String get sectionId => (origin as SectionExercisesProvider).sectionId;
}

String _$mostEnrolledCoursesHash() =>
    r'29989f48125939ab41135c54647f8b09bab8f752';

/// See also [mostEnrolledCourses].
@ProviderFor(mostEnrolledCourses)
final mostEnrolledCoursesProvider =
    AutoDisposeFutureProvider<List<Course>>.internal(
      mostEnrolledCourses,
      name: r'mostEnrolledCoursesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mostEnrolledCoursesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MostEnrolledCoursesRef = AutoDisposeFutureProviderRef<List<Course>>;
String _$recentCoursesHash() => r'1ca4505a9a62982d9162b585078c8b9e57e07ad7';

/// See also [recentCourses].
@ProviderFor(recentCourses)
final recentCoursesProvider = AutoDisposeFutureProvider<List<Course>>.internal(
  recentCourses,
  name: r'recentCoursesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recentCoursesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecentCoursesRef = AutoDisposeFutureProviderRef<List<Course>>;
String _$watchMostEnrolledCoursesHash() =>
    r'63a1b2fbb0c536dd5bb5509b05460de1061a8906';

/// See also [watchMostEnrolledCourses].
@ProviderFor(watchMostEnrolledCourses)
final watchMostEnrolledCoursesProvider =
    AutoDisposeStreamProvider<List<Course>>.internal(
      watchMostEnrolledCourses,
      name: r'watchMostEnrolledCoursesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$watchMostEnrolledCoursesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WatchMostEnrolledCoursesRef =
    AutoDisposeStreamProviderRef<List<Course>>;
String _$coursesNotifierHash() => r'c3f9805ae43fd78596500a1c8555aa9ff7d4aa09';

/// See also [CoursesNotifier].
@ProviderFor(CoursesNotifier)
final coursesNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CoursesNotifier, List<Course>>.internal(
      CoursesNotifier.new,
      name: r'coursesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$coursesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CoursesNotifier = AutoDisposeAsyncNotifier<List<Course>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
