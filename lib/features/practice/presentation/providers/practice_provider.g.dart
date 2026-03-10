// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'practice_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reviewRepositoryHash() => r'a54af7f83c340beb66619dbbe93ea104318cd02e';

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
String _$dueReviewItemsHash() => r'1ad966b890a81474119c27f652b503b917263131';

/// See also [dueReviewItems].
@ProviderFor(dueReviewItems)
final dueReviewItemsProvider =
    AutoDisposeFutureProvider<List<ReviewItem>>.internal(
      dueReviewItems,
      name: r'dueReviewItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dueReviewItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DueReviewItemsRef = AutoDisposeFutureProviderRef<List<ReviewItem>>;
String _$userReviewItemsHash() => r'87264a896bf22d19a75600e7330ab7059ff6c749';

/// See also [userReviewItems].
@ProviderFor(userReviewItems)
final userReviewItemsProvider =
    AutoDisposeFutureProvider<List<ReviewItem>>.internal(
      userReviewItems,
      name: r'userReviewItemsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userReviewItemsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserReviewItemsRef = AutoDisposeFutureProviderRef<List<ReviewItem>>;
String _$practiceNotifierHash() => r'ea7036207ae8d91dac5ec2c6ee42edfd62ec3437';

/// See also [PracticeNotifier].
@ProviderFor(PracticeNotifier)
final practiceNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PracticeNotifier, PracticeState>.internal(
      PracticeNotifier.new,
      name: r'practiceNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$practiceNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PracticeNotifier = AutoDisposeAsyncNotifier<PracticeState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
