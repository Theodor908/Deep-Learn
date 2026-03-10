import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'features/courses/presentation/screens/course_detail_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/home/presentation/screens/learn_redirect_screen.dart';
import 'features/practice/presentation/screens/practice_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/search/presentation/screens/search_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final protectedRoutes = ['/practice', '/learn'];

      if (!isAuthenticated &&
          protectedRoutes.contains(state.matchedLocation)) {
        return '/login';
      }
      if (isAuthenticated && isAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
          GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
          GoRoute(
              path: '/practice', builder: (_, _) => const PracticeScreen()),
          GoRoute(
              path: '/learn', builder: (_, _) => const LearnRedirectScreen()),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
      GoRoute(
        path: '/course/:courseId',
        builder: (_, state) => CourseDetailScreen(
          courseId: state.pathParameters['courseId']!,
        ),
      ),
      GoRoute(
        path: '/admin',
        builder: (_, _) => const AdminDashboardScreen(),
      ),
    ],
  );
});

class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.valueOrNull != null;
    final location = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location, isAuthenticated),
        onDestinationSelected: (index) =>
            _onTap(context, index, isAuthenticated),
        destinations: [
          NavigationDestination(
            icon: PhosphorIcon(PhosphorIcons.house()),
            selectedIcon:
                PhosphorIcon(PhosphorIcons.house(PhosphorIconsStyle.fill)),
            label: 'Home',
          ),
          NavigationDestination(
            icon: PhosphorIcon(PhosphorIcons.magnifyingGlass()),
            selectedIcon: PhosphorIcon(
                PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.fill)),
            label: 'Search',
          ),
          if (isAuthenticated)
            NavigationDestination(
              icon: PhosphorIcon(PhosphorIcons.brain()),
              selectedIcon:
                  PhosphorIcon(PhosphorIcons.brain(PhosphorIconsStyle.fill)),
              label: 'Practice',
            ),
          if (isAuthenticated)
            NavigationDestination(
              icon: PhosphorIcon(PhosphorIcons.bookOpen()),
              selectedIcon:
                  PhosphorIcon(PhosphorIcons.bookOpen(PhosphorIconsStyle.fill)),
              label: 'Learn',
            ),
          NavigationDestination(
            icon: PhosphorIcon(PhosphorIcons.user()),
            selectedIcon:
                PhosphorIcon(PhosphorIcons.user(PhosphorIconsStyle.fill)),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(String location, bool isAuthenticated) {
    if (location == '/') return 0;
    if (location == '/search') return 1;
    if (isAuthenticated) {
      if (location == '/practice') return 2;
      if (location == '/learn') return 3;
      if (location == '/profile') return 4;
    } else {
      if (location == '/profile') return 2;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index, bool isAuthenticated) {
    final routes = isAuthenticated
        ? ['/', '/search', '/practice', '/learn', '/profile']
        : ['/', '/search', '/profile'];
    if (index < routes.length) context.go(routes[index]);
  }
}

class DeepLearnApp extends ConsumerWidget {
  const DeepLearnApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Deep Learn',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
