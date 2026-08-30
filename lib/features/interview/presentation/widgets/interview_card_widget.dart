import 'package:flutter/material.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/interview_entity.dart';

class InterviewCardWidget extends StatelessWidget {
  final InterviewEntity interview;
  final VoidCallback? onTap;

  const InterviewCardWidget({
    super.key,
    required this.interview,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StatusBadge(
                    status: interview.type,
                    isInterviewType: true,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      interview.scheduledAt.toDateTimeString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    size: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    interview.formattedDuration,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  if (interview.location != null &&
                      interview.location!.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        interview.location!,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (interview.meetingUrl != null &&
                  interview.meetingUrl!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.videocam_outlined,
                      size: 13,
                      color: Colors.teal,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        interview.meetingUrl!,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.teal,
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
