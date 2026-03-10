// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sectionSearchResultsHash() =>
    r'825a9d9791a149266071a032f5c6a28c1ce6e1d2';

/// See also [sectionSearchResults].
@ProviderFor(sectionSearchResults)
final sectionSearchResultsProvider =
    AutoDisposeFutureProvider<List<Section>>.internal(
      sectionSearchResults,
      name: r'sectionSearchResultsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$sectionSearchResultsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SectionSearchResultsRef = AutoDisposeFutureProviderRef<List<Section>>;
String _$searchNotifierHash() => r'a34014775ee3dbbefc3cef23af1f1a229583e2cc';

/// See also [SearchNotifier].
@ProviderFor(SearchNotifier)
final searchNotifierProvider =
    AutoDisposeAsyncNotifierProvider<SearchNotifier, List<Course>>.internal(
      SearchNotifier.new,
      name: r'searchNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$searchNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SearchNotifier = AutoDisposeAsyncNotifier<List<Course>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
