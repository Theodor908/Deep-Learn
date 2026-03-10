import 'dart:async';

import 'package:deep_learn/features/auth/domain/entities/app_user.dart';
import 'package:deep_learn/features/auth/domain/repositories/auth_repository.dart';
import 'package:deep_learn/features/auth/presentation/providers/auth_provider.dart';
import 'package:deep_learn/features/courses/domain/entities/course.dart';
import 'package:deep_learn/features/courses/domain/entities/enrollment.dart';
import 'package:deep_learn/features/courses/domain/repositories/course_repository.dart';
import 'package:deep_learn/features/courses/domain/repositories/enrollment_repository.dart';
import 'package:deep_learn/features/courses/presentation/providers/course_provider.dart';
import 'package:deep_learn/features/courses/presentation/providers/enrollment_provider.dart';
import 'package:deep_learn/features/home/presentation/screens/home_screen.dart';
import 'package:deep_learn/features/home/presentation/widgets/cta_banner.dart';
import 'package:deep_learn/features/practice/domain/entities/review_item.dart';
import 'package:deep_learn/features/practice/domain/repositories/review_repository.dart';
import 'package:deep_learn/features/practice/presentation/providers/practice_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockCourseRepository extends Mock implements CourseRepository {}

class MockEnrollmentRepository extends Mock implements EnrollmentRepository {}

class MockReviewRepository extends Mock implements ReviewRepository {}

final _sampleCourses = [
  Course(
    id: 'course-1',
    title: 'Intro to Flutter',
    description: 'Learn Flutter basics',
    imageUrl: 'https://example.com/flutter.png',
    categoryIds: ['cat-1'],
    totalSections: 5,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
    enrollmentCount: 120,
  ),
  Course(
    id: 'course-2',
    title: 'Advanced Dart',
    description: 'Master Dart language',
    imageUrl: 'https://example.com/dart.png',
    categoryIds: ['cat-2'],
    totalSections: 8,
    createdAt: DateTime(2026, 2, 1),
    updatedAt: DateTime(2026, 2, 1),
    enrollmentCount: 85,
  ),
];

final _testUser = AppUser(
  uid: 'uid-123',
  username: 'johndoe',
  email: 'john@example.com',
  displayName: 'John Doe',
  createdAt: DateTime(2026, 1, 1),
);

void main() {
  late MockAuthRepository mockAuthRepo;
  late MockCourseRepository mockCourseRepo;
  late MockEnrollmentRepository mockEnrollmentRepo;
  late MockReviewRepository mockReviewRepo;

  setUp(() {
    mockAuthRepo = MockAuthRepository();
    mockCourseRepo = MockCourseRepository();
    mockEnrollmentRepo = MockEnrollmentRepository();
    mockReviewRepo = MockReviewRepository();

    when(() => mockCourseRepo.getMostEnrolledCourses(limit: any(named: 'limit')))
        .thenAnswer((_) async => _sampleCourses);
    when(() => mockCourseRepo.getRecentCourses(limit: any(named: 'limit')))
        .thenAnswer((_) async => _sampleCourses);
    when(() => mockCourseRepo.watchMostEnrolledCourses(limit: any(named: 'limit')))
        .thenAnswer((_) => Stream.value(_sampleCourses));
    when(() => mockCourseRepo.getCourseById(any()))
        .thenAnswer((_) async => _sampleCourses.first);
    when(() => mockEnrollmentRepo.getUserEnrollments(any()))
        .thenAnswer((_) async => []);
    when(() => mockEnrollmentRepo.getRecommendedCourses(any(),
        limit: any(named: 'limit'))).thenAnswer((_) async => []);
    when(() => mockReviewRepo.getDueReviewItems(any()))
        .thenAnswer((_) async => []);
  });

  Widget buildSubject({AppUser? user}) {
    final isAuthenticated = user != null;

    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepo),
        authStateProvider.overrideWith(
          (ref) => isAuthenticated ? Stream.value(user) : Stream.value(null),
        ),
        courseRepositoryProvider.overrideWithValue(mockCourseRepo),
        mostEnrolledCoursesProvider.overrideWith(
          (ref) async => _sampleCourses,
        ),
        recentCoursesProvider.overrideWith(
          (ref) async => _sampleCourses,
        ),
        enrollmentRepositoryProvider.overrideWithValue(mockEnrollmentRepo),
        userEnrollmentsProvider.overrideWith(
          (ref) async => isAuthenticated
              ? [
                  Enrollment(
                    userId: user!.uid,
                    courseId: 'course-1',
                    enrolledAt: DateTime(2026, 1, 5),
                    lastAccessedAt: DateTime(2026, 3, 1),
                    completionPercentage: 0.6,
                    completedSections: [1, 2, 3],
                  ),
                ]
              : <Enrollment>[],
        ),
        recommendedCoursesProvider.overrideWith(
          (ref) async => isAuthenticated ? _sampleCourses : <Course>[],
        ),
        reviewRepositoryProvider.overrideWithValue(mockReviewRepo),
        dueReviewItemsProvider.overrideWith(
          (ref) async => isAuthenticated
              ? [
                  ReviewItem(
                    userId: user!.uid,
                    courseId: 'course-1',
                    sectionId: 'section-1',
                    nextReviewAt:
                        DateTime.now().subtract(const Duration(days: 2)),
                  ),
                ]
              : <ReviewItem>[],
        ),
      ],
      child: const MaterialApp(
        home: HomeScreen(),
      ),
    );
  }

  group('HomeScreen — non-authenticated', () {
    testWidgets('should show Deep Learn title in app bar', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Deep Learn'), findsOneWidget);
    });

    testWidgets('should show Sign In button', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('should show Most Taken Paths section', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(find.text('Most Taken Paths'), findsOneWidget);
    });

    testWidgets('should show Recent Endeavours section', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // May be off-screen; check including offstage widgets.
      expect(
        find.text('Recent Endeavours', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('should show CTA banner', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // CTA banner widget exists in the tree even if scrolled off.
      expect(find.byType(CtaBanner, skipOffstage: false), findsOneWidget);
    });

    testWidgets('should show course cards', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      // Course title appears in the horizontal list (may appear multiple times
      // across "Most Taken" and "Recent" sections).
      expect(
        find.text('Intro to Flutter', skipOffstage: false),
        findsWidgets,
      );
    });

    testWidgets('should not show auth-only sections', (tester) async {
      await tester.pumpWidget(buildSubject());
      await tester.pumpAndSettle();

      expect(
        find.text('Your Learning Paths', skipOffstage: false),
        findsNothing,
      );
      expect(
        find.text('Suggested For You', skipOffstage: false),
        findsNothing,
      );
      expect(
        find.text('Practice to not forget', skipOffstage: false),
        findsNothing,
      );
    });
  });

  group('HomeScreen — authenticated', () {
    testWidgets('should show Hello greeting with surname', (tester) async {
      await tester.pumpWidget(buildSubject(user: _testUser));
      await tester.pumpAndSettle();

      expect(find.text('Hello Doe'), findsOneWidget);
    });

    testWidgets('should show subtitle prompt', (tester) async {
      await tester.pumpWidget(buildSubject(user: _testUser));
      await tester.pumpAndSettle();

      expect(find.text('Ready to learn something new?'), findsOneWidget);
    });

    testWidgets('should show Your Learning Paths section', (tester) async {
      await tester.pumpWidget(buildSubject(user: _testUser));
      await tester.pumpAndSettle();

      expect(find.text('Your Learning Paths'), findsOneWidget);
    });

    testWidgets('should show Recent Endeavours section', (tester) async {
      await tester.pumpWidget(buildSubject(user: _testUser));
      await tester.pumpAndSettle();

      expect(
        find.text('Recent Endeavours', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('should show Suggested For You section', (tester) async {
      await tester.pumpWidget(buildSubject(user: _testUser));
      await tester.pumpAndSettle();

      expect(
        find.text('Suggested For You', skipOffstage: false),
        findsOneWidget,
      );
    });

    testWidgets('should show Practice to not forget section', (tester) async {
      await tester.pumpWidget(buildSubject(user: _testUser));
      await tester.pumpAndSettle();

      // Scroll down to reveal the last section, which is beyond the viewport.
      final verticalList = find.byWidgetPredicate(
        (w) => w is ListView && w.scrollDirection == Axis.vertical,
      );
      await tester.drag(verticalList, const Offset(0, -600));
      await tester.pumpAndSettle();

      expect(find.text('Practice to not forget'), findsOneWidget);
    });

    testWidgets('should not show CTA banner when authenticated',
        (tester) async {
      await tester.pumpWidget(buildSubject(user: _testUser));
      await tester.pumpAndSettle();

      expect(find.byType(CtaBanner, skipOffstage: false), findsNothing);
    });

    testWidgets('should not show Deep Learn title when authenticated',
        (tester) async {
      await tester.pumpWidget(buildSubject(user: _testUser));
      await tester.pumpAndSettle();

      expect(find.text('Deep Learn'), findsNothing);
    });
  });
}
