import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/core/constants/app_constants.dart';
import 'package:job_tracker/core/extensions/context_extensions.dart';
import 'package:job_tracker/core/extensions/date_extensions.dart';
import 'package:job_tracker/core/extensions/string_extensions.dart';
import 'package:job_tracker/core/theme/app_colors.dart';
import 'package:job_tracker/core/widgets/empty_state_widget.dart';
import 'package:job_tracker/core/widgets/loading_indicator.dart';
import 'package:job_tracker/core/widgets/responsive_scaffold.dart';
import 'package:job_tracker/core/widgets/status_badge.dart';
import 'package:job_tracker/features/application/presentation/bloc/application_bloc.dart';
import 'package:job_tracker/features/application/presentation/bloc/application_event.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:job_tracker/features/interview/domain/entities/interview_entity.dart';
import 'package:job_tracker/features/interview/domain/usecases/get_interviews_by_app_usecase.dart';
import 'package:job_tracker/features/interview/presentation/widgets/interview_card_widget.dart';
import '../bloc/application_detail_bloc.dart';
import '../bloc/application_detail_event.dart';
import '../bloc/application_detail_state.dart';
import '../widgets/timeline_item_widget.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final String applicationId;

  const ApplicationDetailScreen({
    super.key,
    required this.applicationId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ApplicationDetailBloc>()
        ..add(LoadApplicationDetailEvent(applicationId)),
      child: ApplicationDetailView(applicationId: applicationId),
    );
  }
}

class ApplicationDetailView extends StatefulWidget {
  final String applicationId;

  const ApplicationDetailView({
    super.key,
    required this.applicationId,
  });

  @override
  State<ApplicationDetailView> createState() => _ApplicationDetailViewState();
}

class _ApplicationDetailViewState extends State<ApplicationDetailView> {
  List<InterviewEntity> _interviews = [];
  bool _isLoadingInterviews = false;

  @override
  void initState() {
    super.initState();
    _fetchInterviews();
  }

  Future<void> _fetchInterviews() async {
    setState(() => _isLoadingInterviews = true);
    final getInterviews = GetIt.I<GetInterviewsByAppUseCase>();
    final result = await getInterviews(
      GetInterviewsByAppParams(applicationId: widget.applicationId),
    );
    if (mounted) {
      setState(() {
        _isLoadingInterviews = false;
        result.fold((_) => _interviews = [], (list) => _interviews = list);
      });
    }
  }

  void _showStatusChangeDialog(BuildContext parentContext, String currentStatus) {
    String selectedStatus = currentStatus;
    final notesController = TextEditingController();
    final detailBloc = parentContext.read<ApplicationDetailBloc>();
    final appBloc = parentContext.read<ApplicationBloc>();
    final dashboardBloc = parentContext.read<DashboardBloc>();

    showDialog(
      context: parentContext,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Update Pipeline Status', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Select New Stage:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  initialValue: selectedStatus,
                  items: AppConstants.applicationStatuses.map((s) {
                    return DropdownMenuItem(
                      value: s,
                      child: Text(s.toTitleCaseFromSnake()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedStatus = val);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Status Change Notes (Optional)',
                    hintText: 'e.g. Cleared HR screening call',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                detailBloc.add(
                  ChangeApplicationStatusEvent(
                    id: widget.applicationId,
                    newStatus: selectedStatus,
                    notes: notesController.text.trim().isNotEmpty
                        ? notesController.text.trim()
                        : null,
                  ),
                );
                appBloc.add(const LoadApplicationsEvent(refresh: true));
                dashboardBloc.add(const LoadDashboardDataEvent(refresh: true));
                parentContext.showSnackBar('Status updated to ${selectedStatus.toTitleCaseFromSnake()}!');
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ResponsiveScaffold(
      maxWidth: 900,
      appBar: AppBar(
        title: const Text('Application Overview'),
        actions: [
          BlocBuilder<ApplicationDetailBloc, ApplicationDetailState>(
            builder: (context, state) {
              if (state.application == null) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit Application',
                onPressed: () async {
                  final updated = await context.push<bool>(
                    '/applications/${state.application!.id}/edit',
                    extra: state.application,
                  );
                  if (updated == true && context.mounted) {
                    context
                        .read<ApplicationDetailBloc>()
                        .add(LoadApplicationDetailEvent(widget.applicationId));
                  }
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ApplicationDetailBloc, ApplicationDetailState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          if (state.application == null) {
            if (state.status == ApplicationDetailStatus.error) {
              return EmptyStateWidget(
                icon: Icons.error_outline,
                title: 'Could not load application',
                description: state.errorMessage ?? 'Please check your connection and retry.',
                actionText: 'Retry',
                isError: true,
                onAction: () {
                  context
                      .read<ApplicationDetailBloc>()
                      .add(LoadApplicationDetailEvent(widget.applicationId));
                },
              );
            }
            return const LoadingIndicator(message: 'Loading application details...');
          }

          final app = state.application!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                              child: Text(
                                app.company.isNotEmpty ? app.company[0].toUpperCase() : 'C',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    app.position,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    app.company,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            StatusBadge(status: app.status, fontSize: 13),
                            const Spacer(),
                            OutlinedButton.icon(
                              onPressed: () => _showStatusChangeDialog(context, app.status),
                              icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                              label: const Text('Change Status'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1),
                        const SizedBox(height: 16),
                        // Metadata Grid
                        Wrap(
                          spacing: 24,
                          runSpacing: 12,
                          children: [
                            _buildMetaField(
                              context,
                              icon: Icons.location_on_outlined,
                              label: 'Location',
                              value: app.location ?? 'Not specified',
                            ),
                            _buildMetaField(
                              context,
                              icon: Icons.attach_money_rounded,
                              label: 'Compensation',
                              value: app.formattedSalary,
                            ),
                            if (app.appliedAt != null)
                              _buildMetaField(
                                context,
                                icon: Icons.calendar_today_outlined,
                                label: 'Date Applied',
                                value: app.appliedAt!.toMediumDate(),
                              ),
                          ],
                        ),
                        if (app.notes != null && app.notes!.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text('Notes:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(app.notes!, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.8))),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Interview Rounds Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Interviews & Rounds', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () async {
                        final created = await context.push<bool>(
                          '/applications/${widget.applicationId}/interviews/create',
                        );
                        if (created == true) _fetchInterviews();
                      },
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Round'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_isLoadingInterviews)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_interviews.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'No interviews scheduled yet. Tap "Add Round" above.',
                          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                      ),
                    ),
                  )
                else
                  ..._interviews.map(
                    (interview) => InterviewCardWidget(
                      interview: interview,
                      onTap: () async {
                        await context.push('/interviews/${interview.id}', extra: interview);
                        _fetchInterviews();
                      },
                    ),
                  ),

                const SizedBox(height: 24),

                // Status Timeline
                Text('Status History Timeline', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (state.events.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'Initial stage recorded on ${app.createdAt.toShortDate()}',
                          style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                      ),
                    ),
                  )
                else
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.events.length,
                        itemBuilder: (context, index) {
                          return TimelineItemWidget(
                            event: state.events[index],
                            isFirst: index == 0,
                            isLast: index == state.events.length - 1,
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetaField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
