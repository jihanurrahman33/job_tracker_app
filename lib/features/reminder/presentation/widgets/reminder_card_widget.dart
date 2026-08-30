import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/reminder_entity.dart';

class ReminderCardWidget extends StatelessWidget {
  final ReminderEntity reminder;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTap;

  const ReminderCardWidget({
    super.key,
    required this.reminder,
    required this.onToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isOverdue = reminder.isOverdue;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: reminder.completed,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                activeColor: AppColors.secondary,
                onChanged: (val) {
                  if (val != null) onToggle(val);
                },
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        decoration: reminder.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: reminder.completed
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    if (reminder.description != null &&
                        reminder.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        reminder.description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                          decoration: reminder.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 13,
                          color: isOverdue
                              ? AppColors.statusRejected
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          reminder.remindAt.toRelativeString(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isOverdue ? FontWeight.bold : FontWeight.w500,
                            color: isOverdue
                                ? AppColors.statusRejected
                                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        if (isOverdue) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.statusRejected.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'OVERDUE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: AppColors.statusRejected,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
