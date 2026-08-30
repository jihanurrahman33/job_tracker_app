import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toShortDate() {
    return DateFormat('MMM d, yyyy').format(toLocal());
  }

  String toMediumDate() {
    return DateFormat('MMMM d, yyyy').format(toLocal());
  }

  String toDateTimeString() {
    return DateFormat('MMM d, yyyy • h:mm a').format(toLocal());
  }

  String toTimeString() {
    return DateFormat('h:mm a').format(toLocal());
  }

  String toRelativeString() {
    final now = DateTime.now();
    final difference = this.difference(now);

    if (difference.inDays == 0) {
      if (difference.isNegative) {
        final positiveDiff = difference.abs();
        if (positiveDiff.inHours == 0) {
          return '${positiveDiff.inMinutes}m ago';
        }
        return '${positiveDiff.inHours}h ago';
      } else {
        if (difference.inHours == 0) {
          return 'in ${difference.inMinutes}m';
        }
        return 'Today at ${toTimeString()}';
      }
    } else if (difference.inDays == 1) {
      return 'Tomorrow at ${toTimeString()}';
    } else if (difference.inDays == -1) {
      return 'Yesterday';
    } else if (difference.inDays > 1 && difference.inDays < 7) {
      return 'in ${difference.inDays} days';
    } else if (difference.inDays < -1 && difference.inDays > -7) {
      return '${difference.inDays.abs()} days ago';
    }

    return toShortDate();
  }
}
