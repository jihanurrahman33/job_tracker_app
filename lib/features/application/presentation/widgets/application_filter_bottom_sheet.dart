import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/string_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class ApplicationFilterBottomSheet extends StatelessWidget {
  final String? currentStatus;
  final ValueChanged<String?> onStatusSelected;

  const ApplicationFilterBottomSheet({
    super.key,
    required this.currentStatus,
    required this.onStatusSelected,
  });

  static Future<void> show(
    BuildContext context, {
    required String? currentStatus,
    required ValueChanged<String?> onStatusSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => ApplicationFilterBottomSheet(
        currentStatus: currentStatus,
        onStatusSelected: onStatusSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter by Status',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (currentStatus != null)
                  TextButton(
                    onPressed: () {
                      onStatusSelected(null);
                      Navigator.pop(context);
                    },
                    child: const Text('Clear Filter'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All Statuses'),
                  selected: currentStatus == null,
                  onSelected: (selected) {
                    if (selected) {
                      onStatusSelected(null);
                      Navigator.pop(context);
                    }
                  },
                ),
                ...AppConstants.applicationStatuses.map((status) {
                  final isSelected = currentStatus == status;
                  final color = AppColors.getStatusColor(status);

                  return ChoiceChip(
                    label: Text(status.toTitleCaseFromSnake()),
                    selected: isSelected,
                    selectedColor: color.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? color : null,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      onStatusSelected(selected ? status : null);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
