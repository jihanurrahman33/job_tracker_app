import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../application/presentation/bloc/application_bloc.dart';
import '../../application/presentation/bloc/application_event.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';
import '../../auth/presentation/bloc/auth_state.dart';
import '../../reminder/presentation/bloc/reminder_bloc.dart';
import '../../reminder/presentation/bloc/reminder_event.dart';
import '../../reminder/presentation/bloc/reminder_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/quick_stats_overview.dart';
import '../widgets/rate_metric_card.dart';
import '../widgets/status_breakdown_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  void _refreshAll() {
    context.read<DashboardBloc>().add(const LoadDashboardDataEvent(refresh: true));
    context.read<ReminderBloc>().add(const LoadRemindersEvent(refresh: true));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ResponsiveScaffold(
      maxWidth: 900,
      appBar: AppBar(
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final userName = state.user?.name ?? 'Job Seeker';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $userName 👋',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Track your career pipeline',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          if (state.status == DashboardStatus.loading && state.statistics == null) {
            return const LoadingIndicator(message: 'Loading dashboard metrics...');
          }

          if (state.status == DashboardStatus.error && state.statistics == null) {
            return EmptyStateWidget(
              icon: Icons.bar_chart_rounded,
              title: 'Could not load statistics',
              description: state.errorMessage ?? 'Please check your connection and retry.',
              actionText: 'Retry',
              isError: true,
              onAction: _refreshAll,
            );
          }

          final stats = state.statistics;
          final totalApps = stats?.totalApplications ?? 0;
          final byStatus = stats?.byStatus ?? {};

          return RefreshIndicator(
            onRefresh: () async => _refreshAll(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<ReminderBloc, ReminderState>(
                    builder: (context, reminderState) {
                      final activeInterviews = (byStatus['INTERVIEW'] ?? 0) +
                          (byStatus['TECHNICAL_INTERVIEW'] ?? 0);
                      final pendingReminders =
                          reminderState.pendingReminders.length;

                      return QuickStatsOverview(
                        totalApplications: totalApps,
                        activeInterviews: activeInterviews,
                        pendingReminders: pendingReminders,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: RateMetricCard(
                          title: 'Response Rate',
                          rate: stats?.responseRate ?? 0.0,
                          icon: Icons.reply_rounded,
                          color: AppColors.statusApplied,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RateMetricCard(
                          title: 'Interview Rate',
                          rate: stats?.interviewRate ?? 0.0,
                          icon: Icons.groups_rounded,
                          color: AppColors.statusInterview,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: RateMetricCard(
                          title: 'Offer Rate',
                          rate: stats?.offerRate ?? 0.0,
                          icon: Icons.celebration_rounded,
                          color: AppColors.statusOffer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  StatusBreakdownCard(
                    byStatus: byStatus,
                    totalApplications: totalApps,
                    onStatusTap: (status) {
                      context
                          .read<ApplicationBloc>()
                          .add(FilterStatusChangedEvent(status));
                      context.go('/applications');
                    },
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => context.push('/applications/create'),
                                  icon: const Icon(Icons.add_circle_outline, size: 18),
                                  label: const Text('Add Job'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: () => context.push('/reminders/create'),
                                  icon: const Icon(Icons.alarm_add_rounded, size: 18),
                                  label: const Text('Reminder'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
