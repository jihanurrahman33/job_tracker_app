import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/features/application/domain/entities/application_entity.dart';
import 'package:job_tracker/features/application/presentation/bloc/application_bloc.dart';
import 'package:job_tracker/features/application/presentation/bloc/application_event.dart';
import 'package:job_tracker/features/application/presentation/screens/application_detail_screen.dart';
import 'package:job_tracker/features/application/presentation/screens/application_form_screen.dart';
import 'package:job_tracker/features/application/presentation/screens/application_list_screen.dart';
import 'package:job_tracker/features/auth/presentation/screens/login_screen.dart';
import 'package:job_tracker/features/auth/presentation/screens/register_screen.dart';
import 'package:job_tracker/features/auth/presentation/screens/splash_screen.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:job_tracker/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:job_tracker/features/interview/domain/entities/interview_entity.dart';
import 'package:job_tracker/features/interview/presentation/screens/interview_detail_screen.dart';
import 'package:job_tracker/features/interview/presentation/screens/interview_form_screen.dart';
import 'package:job_tracker/features/reminder/domain/entities/reminder_entity.dart';
import 'package:job_tracker/features/reminder/presentation/bloc/reminder_bloc.dart';
import 'package:job_tracker/features/reminder/presentation/bloc/reminder_event.dart';
import 'package:job_tracker/features/reminder/presentation/screens/reminder_form_screen.dart';
import 'package:job_tracker/features/reminder/presentation/screens/reminder_list_screen.dart';
import 'package:job_tracker/features/settings/presentation/screens/settings_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _dashboardNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _applicationsNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _remindersNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _settingsNavigatorKey =
    GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _dashboardNavigatorKey,
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _applicationsNavigatorKey,
            routes: [
              GoRoute(
                path: '/applications',
                builder: (context, state) => const ApplicationListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ApplicationFormScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return ApplicationDetailScreen(applicationId: id);
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final app = state.extra as ApplicationEntity?;
                          return ApplicationFormScreen(application: app);
                        },
                      ),
                      GoRoute(
                        path: 'interviews/create',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final appId = state.pathParameters['id']!;
                          return InterviewFormScreen(applicationId: appId);
                        },
                      ),
                      GoRoute(
                        path: 'interviews/:interviewId/edit',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final appId = state.pathParameters['id']!;
                          final interview = state.extra as InterviewEntity?;
                          return InterviewFormScreen(
                            applicationId: appId,
                            interview: interview,
                          );
                        },
                      ),
                      GoRoute(
                        path: 'reminders/create',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (context, state) {
                          final appId = state.pathParameters['id']!;
                          return ReminderFormScreen(applicationId: appId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _remindersNavigatorKey,
            routes: [
              GoRoute(
                path: '/reminders',
                builder: (context, state) => const ReminderListScreen(),
                routes: [
                  GoRoute(
                    path: 'create',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ReminderFormScreen(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final reminder = state.extra as ReminderEntity?;
                      return ReminderFormScreen(reminder: reminder);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _settingsNavigatorKey,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/interviews/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final interview = state.extra as InterviewEntity;
          return InterviewDetailScreen(interview: interview);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.error}'),
      ),
    ),
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onDestinationSelected(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );

    // Refresh state when switching tabs
    if (index == 0) {
      context.read<DashboardBloc>().add(const LoadDashboardDataEvent(refresh: true));
      context.read<ReminderBloc>().add(const LoadRemindersEvent(refresh: true));
    } else if (index == 1) {
      context.read<ApplicationBloc>().add(const LoadApplicationsEvent(refresh: true));
    } else if (index == 2) {
      context.read<ReminderBloc>().add(const LoadRemindersEvent(refresh: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => _onDestinationSelected(context, index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline_rounded),
            selectedIcon: Icon(Icons.work_rounded),
            label: 'Applications',
          ),
          NavigationDestination(
            icon: Icon(Icons.alarm_outlined),
            selectedIcon: Icon(Icons.alarm_on_rounded),
            label: 'Reminders',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
