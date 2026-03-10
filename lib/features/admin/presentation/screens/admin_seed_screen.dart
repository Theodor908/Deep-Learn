import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AdminSeedScreen extends ConsumerStatefulWidget {
  const AdminSeedScreen({super.key});

  @override
  ConsumerState<AdminSeedScreen> createState() => _AdminSeedScreenState();
}

class _AdminSeedScreenState extends ConsumerState<AdminSeedScreen> {
  final _log = <String>[];
  bool _isRunning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(
          'Seed Database',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIcons.arrowLeft(), size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      PhosphorIcon(
                        PhosphorIcons.warning(),
                        size: 20,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'This will add 15 fake users, enrollments, ratings, and reviews. Your account will be set as admin.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _isRunning ? null : _runSeed,
                    icon: _isRunning
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : PhosphorIcon(PhosphorIcons.database(), size: 20),
                    label: Text(
                      _isRunning ? 'Seeding...' : 'Seed Users & Reviews',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          AppColors.primary.withValues(alpha: 0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A2E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                itemCount: _log.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _log[i],
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Color(0xFF4ECDC4),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addLog(String message) {
    setState(() => _log.add(message));
  }

  Future<void> _runSeed() async {
    setState(() {
      _isRunning = true;
      _log.clear();
    });

    try {
      final db = FirebaseFirestore.instance;
      final user = ref.read(authStateProvider).valueOrNull;

      _addLog('Starting seed...');

      // Seed users
      _addLog('Creating 15 fake users...');
      await _seedUsers(db);
      _addLog('  Done.');

      // Seed enrollments, ratings, reviews
      _addLog('Creating enrollments, ratings, reviews...');
      final counts = await _seedEnrollmentsAndReviews(db);
      _addLog('  ${counts.$1} enrollments, ${counts.$2} reviews created.');

      // Set current user as admin
      if (user != null) {
        _addLog('Setting ${user.displayName} as admin...');
        await db.collection('users').doc(user.uid).update({'role': 'admin'});
        _addLog('  Done.');
      }

      _addLog('');
      _addLog('Seed complete!');
    } catch (e) {
      _addLog('ERROR: $e');
    } finally {
      setState(() => _isRunning = false);
    }
  }

  Future<void> _seedUsers(FirebaseFirestore db) async {
    final now = Timestamp.now();

    final users = [
      {'uid': 'user_01', 'displayName': 'Alex Johnson', 'email': 'alex.johnson@example.com'},
      {'uid': 'user_02', 'displayName': 'Maria Garcia', 'email': 'maria.garcia@example.com'},
      {'uid': 'user_03', 'displayName': 'James Chen', 'email': 'james.chen@example.com'},
      {'uid': 'user_04', 'displayName': 'Sofia Müller', 'email': 'sofia.muller@example.com'},
      {'uid': 'user_05', 'displayName': "Liam O'Brien", 'email': 'liam.obrien@example.com'},
      {'uid': 'user_06', 'displayName': 'Yuki Tanaka', 'email': 'yuki.tanaka@example.com'},
      {'uid': 'user_07', 'displayName': 'Priya Patel', 'email': 'priya.patel@example.com'},
      {'uid': 'user_08', 'displayName': 'Noah Williams', 'email': 'noah.williams@example.com'},
      {'uid': 'user_09', 'displayName': 'Emma Davis', 'email': 'emma.davis@example.com'},
      {'uid': 'user_10', 'displayName': 'Lucas Martin', 'email': 'lucas.martin@example.com'},
      {'uid': 'user_11', 'displayName': 'Aisha Khan', 'email': 'aisha.khan@example.com'},
      {'uid': 'user_12', 'displayName': 'Daniel Kim', 'email': 'daniel.kim@example.com'},
      {'uid': 'user_13', 'displayName': 'Olivia Brown', 'email': 'olivia.brown@example.com'},
      {'uid': 'user_14', 'displayName': 'Ethan Lee', 'email': 'ethan.lee@example.com'},
      {'uid': 'user_15', 'displayName': 'Fatima Ali', 'email': 'fatima.ali@example.com'},
    ];

    final batch = db.batch();
    for (final user in users) {
      batch.set(db.collection('users').doc(user['uid'] as String), {
        'username': (user['displayName'] as String).toLowerCase().replaceAll(' ', '_'),
        'email': user['email'],
        'displayName': user['displayName'],
        'photoUrl': null,
        'createdAt': now,
        'role': 'user',
      });
    }
    await batch.commit();
  }

  Future<(int, int)> _seedEnrollmentsAndReviews(FirebaseFirestore db) async {
    // Fetch actual course IDs from Firestore
    final coursesSnapshot = await db.collection('courses').get();
    if (coursesSnapshot.docs.isEmpty) {
      _addLog('  No courses found in Firestore. Add courses first.');
      return (0, 0);
    }

    final courseIds = coursesSnapshot.docs.map((d) => d.id).toList();
    final courseSectionCounts = <String, int>{};
    for (final doc in coursesSnapshot.docs) {
      courseSectionCounts[doc.id] = (doc.data()['totalSections'] as int?) ?? 3;
    }

    _addLog('  Found ${courseIds.length} courses.');

    // Build enrollments dynamically: each of the 15 users enrolls in 3 courses
    final userIds = List.generate(15, (i) => 'user_${(i + 1).toString().padLeft(2, '0')}');
    final ratings = [5, 4, 3, 5, 4, 3, 5, 4, 0, 4, 5, 3, 4, 5, 4];

    final enrollments = <Map<String, dynamic>>[];
    for (int i = 0; i < userIds.length; i++) {
      // Each user gets 3 courses, cycling through available courses
      for (int j = 0; j < 3; j++) {
        final courseIndex = (i * 3 + j) % courseIds.length;
        final totalSections = courseSectionCounts[courseIds[courseIndex]] ?? 3;
        final completedCount = (j == 0) ? totalSections : (j == 1) ? (totalSections ~/ 2).clamp(1, totalSections) : 1;
        final completed = List.generate(completedCount, (k) => k + 1);
        enrollments.add({
          'userId': userIds[i],
          'courseId': courseIds[courseIndex],
          'completed': completed,
          'rating': ratings[(i + j) % ratings.length],
        });
      }
    }

    final userNames = <String, String>{
      'user_01': 'Alex Johnson', 'user_02': 'Maria Garcia', 'user_03': 'James Chen',
      'user_04': 'Sofia Müller', 'user_05': "Liam O'Brien", 'user_06': 'Yuki Tanaka',
      'user_07': 'Priya Patel', 'user_08': 'Noah Williams', 'user_09': 'Emma Davis',
      'user_10': 'Lucas Martin', 'user_11': 'Aisha Khan', 'user_12': 'Daniel Kim',
      'user_13': 'Olivia Brown', 'user_14': 'Ethan Lee', 'user_15': 'Fatima Ali',
    };

    final reviewTexts = [
      'Great course! Very clear explanations and helpful exercises.',
      'Excellent content, learned a lot in a short time.',
      'Good material but could use more practice exercises.',
      'Well structured and easy to follow. Highly recommend!',
      'The examples are very practical and relevant.',
      'Solid introduction to the topic. Looking forward to advanced content.',
      'Really enjoyed the interactive exercises. Made learning fun!',
      'Content is good but some sections feel a bit rushed.',
      'Perfect for beginners. Covers all the fundamentals.',
      "One of the best courses I've taken on this platform.",
      'Clear, concise, and well-organized. Great job!',
      'The explanations are easy to understand. Very helpful.',
      'Good course overall. A few more examples would be nice.',
      'Loved the hands-on approach. Very engaging content.',
      'Comprehensive coverage of the basics. Well done!',
    ];

    final now = DateTime.now();
    int enrollmentCount = 0;
    int reviewCount = 0;
    final courseRatings = <String, List<int>>{};

    for (final e in enrollments) {
      final userId = e['userId'] as String;
      final courseId = e['courseId'] as String;
      final completed = e['completed'] as List<int>;
      final rating = e['rating'] as int;
      final total = courseSectionCounts[courseId] ?? 3;
      final percentage = completed.length / total;
      final docId = '${userId}_$courseId';

      final enrolledAt = now.subtract(Duration(days: 30 + enrollmentCount * 2));
      await db.collection('enrollments').doc(docId).set({
        'userId': userId,
        'courseId': courseId,
        'enrolledAt': Timestamp.fromDate(enrolledAt),
        'lastAccessedAt': Timestamp.fromDate(
            now.subtract(Duration(days: enrollmentCount % 7))),
        'currentSectionOrder':
            completed.length < total ? completed.length + 1 : total,
        'completedSections': completed,
        'completionPercentage': percentage,
        'rating': rating,
      });
      enrollmentCount++;

      if (rating > 0) {
        courseRatings.putIfAbsent(courseId, () => []);
        courseRatings[courseId]!.add(rating);
      }

      if (rating > 0 &&
          (enrollmentCount % 10 != 3 && enrollmentCount % 10 != 7)) {
        final reviewText =
            reviewTexts[(enrollmentCount * 7 + rating) % reviewTexts.length];
        final reviewDate = enrolledAt.add(const Duration(days: 5));
        await db
            .collection('courses')
            .doc(courseId)
            .collection('reviews')
            .doc(docId)
            .set({
          'userId': userId,
          'courseId': courseId,
          'displayName': userNames[userId],
          'rating': rating,
          'text': reviewText,
          'createdAt': Timestamp.fromDate(reviewDate),
          'updatedAt': Timestamp.fromDate(reviewDate),
        });
        reviewCount++;
      }
    }

    // Update course stats
    final courseEnrollmentCounts = <String, int>{};
    for (final e in enrollments) {
      final courseId = e['courseId'] as String;
      courseEnrollmentCounts[courseId] =
          (courseEnrollmentCounts[courseId] ?? 0) + 1;
    }

    for (final courseId in courseEnrollmentCounts.keys) {
      final ratings = courseRatings[courseId] ?? [];
      final avgRating = ratings.isNotEmpty
          ? ratings.reduce((a, b) => a + b) / ratings.length
          : 0.0;
      await db.collection('courses').doc(courseId).update({
        'enrollmentCount': courseEnrollmentCounts[courseId],
        'averageRating': avgRating,
        'ratingCount': ratings.length,
      });
    }

    return (enrollmentCount, reviewCount);
  }
}
