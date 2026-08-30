import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../bloc/reminder_bloc.dart';
import '../bloc/reminder_event.dart';
import '../bloc/reminder_state.dart';
import '../widgets/reminder_card_widget.dart';

class ReminderListScreen extends StatefulWidget {
  const ReminderListScreen({super.key});

  @override
  State<ReminderListScreen> createState() => _ReminderListScreenState();
}

class _ReminderListScreenState extends State<ReminderListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<ReminderBloc>().add(const LoadRemindersEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      maxWidth: 800,
      appBar: AppBar(
        title: const Text('Reminders & Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await context.push<bool>('/reminders/create');
          if (created == true && mounted) {
            context.read<ReminderBloc>().add(const LoadRemindersEvent(refresh: true));
          }
        },
        icon: const Icon(Icons.add_task_rounded),
        label: const Text('New Reminder'),
      ),
      body: BlocConsumer<ReminderBloc, ReminderState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            context.showSnackBar(state.errorMessage!, isError: true);
          }
        },
        builder: (context, state) {
          if (state.status == ReminderStatus.loading && state.reminders.isEmpty) {
            return const LoadingIndicator(message: 'Loading reminders...');
          }

          if (state.status == ReminderStatus.error && state.reminders.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Could not load reminders',
              description: state.errorMessage ?? 'Please check your connection.',
              actionText: 'Retry',
              isError: true,
              onAction: () {
                context.read<ReminderBloc>().add(const LoadRemindersEvent(refresh: true));
              },
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildReminderList(context, state.pendingReminders, isPending: true),
              _buildReminderList(context, state.completedReminders, isPending: false),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReminderList(
    BuildContext context,
    List dynamicList, {
    required bool isPending,
  }) {
    if (dynamicList.isEmpty) {
      return EmptyStateWidget(
        icon: isPending ? Icons.check_circle_outline_rounded : Icons.task_alt_rounded,
        title: isPending ? 'All caught up!' : 'No completed tasks yet',
        description: isPending
            ? 'No pending follow-ups. Schedule one anytime!'
            : 'Tasks you complete will appear here.',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ReminderBloc>().add(const LoadRemindersEvent(refresh: true));
      },
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
        itemCount: dynamicList.length,
        itemBuilder: (context, index) {
          final reminder = dynamicList[index];

          return Dismissible(
            key: Key(reminder.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) async {
              return await ConfirmationDialog.show(
                context,
                title: 'Delete Reminder',
                content: 'Are you sure you want to delete "${reminder.title}"?',
                confirmText: 'Delete',
                isDestructive: true,
              );
            },
            onDismissed: (_) {
              context.read<ReminderBloc>().add(DeleteReminderEvent(reminder.id));
            },
            background: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete_outline, color: Colors.white),
            ),
            child: ReminderCardWidget(
              reminder: reminder,
              onToggle: (val) {
                context.read<ReminderBloc>().add(
                      ToggleReminderStatusEvent(
                        id: reminder.id,
                        completed: val,
                      ),
                    );
              },
            ),
          );
        },
      ),
    );
  }
}
