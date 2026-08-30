import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/responsive_scaffold.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/interview_entity.dart';
import '../../domain/usecases/delete_interview_usecase.dart';

class InterviewDetailScreen extends StatelessWidget {
  final InterviewEntity interview;

  const InterviewDetailScreen({super.key, required this.interview});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return ResponsiveScaffold(
      maxWidth: 700,
      appBar: AppBar(
        title: const Text('Interview Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Round',
            onPressed: () async {
              final updated = await context.push<bool>(
                '/applications/${interview.applicationId}/interviews/${interview.id}/edit',
                extra: interview,
              );
              if (updated == true && context.mounted) {
                context.pop(true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Delete Round',
            onPressed: () async {
              final confirmed = await ConfirmationDialog.show(
                context,
                title: 'Delete Interview Round',
                content: 'Are you sure you want to delete this interview round?',
                confirmText: 'Delete',
                isDestructive: true,
              );

              if (confirmed == true && context.mounted) {
                final deleteUseCase = GetIt.I<DeleteInterviewUseCase>();
                final result = await deleteUseCase(DeleteInterviewParams(id: interview.id));
                result.fold(
                  (f) => context.showSnackBar(f.message, isError: true),
                  (_) {
                    context.showSnackBar('Interview deleted');
                    context.pop(true);
                  },
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge(
                          status: interview.type,
                          isInterviewType: true,
                          fontSize: 13,
                        ),
                        Text(
                          interview.formattedDuration,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      interview.scheduledAt.toDateTimeString(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    if (interview.location != null &&
                        interview.location!.isNotEmpty) ...[
                      _buildDetailRow(
                        context,
                        icon: Icons.location_on_outlined,
                        title: 'Location',
                        value: interview.location!,
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (interview.meetingUrl != null &&
                        interview.meetingUrl!.isNotEmpty) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.videocam_outlined,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Meeting Link',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  interview.meetingUrl!,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy_rounded, size: 18),
                            tooltip: 'Copy Link',
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: interview.meetingUrl!));
                              context.showSnackBar('Meeting URL copied to clipboard!');
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (interview.notes != null &&
                        interview.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Preparation Notes:',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.6)),
                        ),
                        child: Text(
                          interview.notes!,
                          style: TextStyle(
                            fontSize: 13,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
