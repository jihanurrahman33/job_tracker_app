import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:job_tracker/features/dashboard/presentation/bloc/dashboard_event.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../bloc/application_bloc.dart';
import '../bloc/application_event.dart';
import '../bloc/application_state.dart';
import '../widgets/application_card_widget.dart';
import '../widgets/application_filter_bottom_sheet.dart';

class ApplicationListScreen extends StatefulWidget {
  const ApplicationListScreen({super.key});

  @override
  State<ApplicationListScreen> createState() => _ApplicationListScreenState();
}

class _ApplicationListScreenState extends State<ApplicationListScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ApplicationBloc>().add(const LoadApplicationsEvent());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ApplicationBloc>().add(const LoadMoreApplicationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ResponsiveScaffold(
      maxWidth: 900,
      appBar: AppBar(
        title: const Text('Job Applications',
            style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filter Applications',
            onPressed: () {
              ApplicationFilterBottomSheet.show(
                context,
                currentStatus:
                    context.read<ApplicationBloc>().state.selectedStatus,
                onStatusSelected: (status) {
                  context
                      .read<ApplicationBloc>()
                      .add(FilterStatusChangedEvent(status));
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'New Application',
            onPressed: () async {
              final created = await context.push<bool>('/applications/create');
              if (created == true && mounted) {
                context
                    .read<ApplicationBloc>()
                    .add(const LoadApplicationsEvent(refresh: true));
              }
            },
          ),
        ],
      ),
      body: BlocConsumer<ApplicationBloc, ApplicationState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Search & Filter Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search company, position...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  context
                                      .read<ApplicationBloc>()
                                      .add(const SearchQueryChangedEvent(''));
                                },
                              )
                            : null,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onChanged: (val) {
                        context
                            .read<ApplicationBloc>()
                            .add(SearchQueryChangedEvent(val));
                      },
                    ),
                    if (state.selectedStatus != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('Filtered by:',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              )),
                          const SizedBox(width: 8),
                          Chip(
                            label: Text(
                              state.selectedStatus!.toTitleCaseFromSnake(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            deleteIcon:
                                const Icon(Icons.close_rounded, size: 14),
                            onDeleted: () {
                              context
                                  .read<ApplicationBloc>()
                                  .add(const FilterStatusChangedEvent(null));
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Content List
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.status == ApplicationListStatus.loading &&
                        state.applications.isEmpty) {
                      return const LoadingIndicator(
                          message: 'Loading applications...');
                    }

                    if (state.status == ApplicationListStatus.error &&
                        state.applications.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.error_outline,
                        title: 'Unable to load applications',
                        description: state.errorMessage ??
                            'Please check your connection and retry.',
                        actionText: 'Retry',
                        isError: true,
                        onAction: () {
                          context
                              .read<ApplicationBloc>()
                              .add(const LoadApplicationsEvent(refresh: true));
                        },
                      );
                    }

                    if (state.applications.isEmpty) {
                      return EmptyStateWidget(
                        icon: Icons.work_off_outlined,
                        title: 'No applications found',
                        description: state.selectedStatus != null ||
                                state.searchQuery.isNotEmpty
                            ? 'No jobs match your current filters. Try changing or clearing them.'
                            : 'Start by tracking your first job application!',
                        actionText: state.selectedStatus != null
                            ? 'Clear Filter'
                            : 'Add Job',
                        onAction: () {
                          if (state.selectedStatus != null) {
                            context
                                .read<ApplicationBloc>()
                                .add(const FilterStatusChangedEvent(null));
                          } else {
                            context.push('/applications/create');
                          }
                        },
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        context
                            .read<ApplicationBloc>()
                            .add(const LoadApplicationsEvent(refresh: true));
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                        itemCount:
                            state.applications.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.applications.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          }

                          final application = state.applications[index];

                          return Dismissible(
                            key: Key(application.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) async {
                              return await ConfirmationDialog.show(
                                context,
                                title: 'Delete Application',
                                content:
                                    'Are you sure you want to delete ${application.position} at ${application.company}?',
                                confirmText: 'Delete',
                                isDestructive: true,
                              );
                            },
                            onDismissed: (_) {
                              context.read<ApplicationBloc>().add(
                                  DeleteApplicationItemEvent(application.id));
                              context.read<DashboardBloc>().add(
                                  const LoadDashboardDataEvent(refresh: true));
                            },
                            background: Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.centerRight,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.white),
                            ),
                            child: ApplicationCardWidget(
                              application: application,
                              onTap: () async {
                                await context
                                    .push('/applications/${application.id}');
                                if (context.mounted) {
                                  context.read<ApplicationBloc>().add(
                                      const LoadApplicationsEvent(
                                          refresh: true));
                                  context.read<DashboardBloc>().add(
                                      const LoadDashboardDataEvent(
                                          refresh: true));
                                }
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
