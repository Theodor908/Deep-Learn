import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../courses/domain/entities/course.dart';
import '../../../courses/domain/entities/section.dart';
import '../../../courses/presentation/providers/course_provider.dart';

part 'search_provider.g.dart';

@riverpod
class SearchNotifier extends _$SearchNotifier {
  String _query = '';
  List<String>? _categoryFilter;
  String? _lastCourseId;
  bool _hasMore = true;
  Timer? _debounce;

  @override
  FutureOr<List<Course>> build() async {
    ref.onDispose(() => _debounce?.cancel());
    _query = '';
    _categoryFilter = null;
    _lastCourseId = null;
    _hasMore = true;
    return _fetchCourses();
  }

  Future<List<Course>> _fetchCourses({String? startAfterId}) async {
    final repo = ref.read(courseRepositoryProvider);
    if (_query.isNotEmpty) {
      return repo.searchCourses(_query, categoryIds: _categoryFilter);
    }
    return repo.getCourses(
      categoryIds: _categoryFilter,
      startAfterId: startAfterId,
    );
  }

  void updateQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _query = query.trim();
      _lastCourseId = null;
      _hasMore = _query.isEmpty;
      _reload();
    });
  }

  void toggleCategory(String categoryId) {
    _categoryFilter ??= [];
    if (_categoryFilter!.contains(categoryId)) {
      _categoryFilter!.remove(categoryId);
      if (_categoryFilter!.isEmpty) _categoryFilter = null;
    } else {
      _categoryFilter!.add(categoryId);
    }
    _lastCourseId = null;
    _hasMore = _query.isEmpty;
    _reload();
  }

  Future<void> _reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final courses = await _fetchCourses();
      if (_query.isEmpty) {
        _lastCourseId = courses.isNotEmpty ? courses.last.id : null;
        _hasMore = courses.length >= 10;
      }
      return courses;
    });
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading || _query.isNotEmpty) return;

    final current = state.valueOrNull ?? [];
    state = await AsyncValue.guard(() async {
      final next = await _fetchCourses(startAfterId: _lastCourseId);
      _lastCourseId = next.isNotEmpty ? next.last.id : null;
      _hasMore = next.length >= 10;
      return [...current, ...next];
    });
  }

  bool get hasMore => _hasMore;

  String get currentQuery => _query;

  Set<String> get selectedCategoryIds =>
      _categoryFilter?.toSet() ?? <String>{};
}

@riverpod
Future<List<Section>> sectionSearchResults(
    SectionSearchResultsRef ref) async {
  final searchState = ref.watch(searchNotifierProvider.notifier);
  final query = searchState.currentQuery;
  if (query.isEmpty) return [];

  final repo = ref.watch(courseRepositoryProvider);
  return repo.searchSections(query);
}
