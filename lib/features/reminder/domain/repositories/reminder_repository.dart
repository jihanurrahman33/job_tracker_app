import '../../../../core/error/failures.dart';
import '../../../../core/utils/either.dart';
import '../entities/reminder_entity.dart';

abstract class ReminderRepository {
  Future<Either<Failure, List<ReminderEntity>>> getReminders();

  Future<Either<Failure, ReminderEntity>> createReminder({
    String? applicationId,
    required String title,
    String? description,
    required DateTime remindAt,
  });

  Future<Either<Failure, ReminderEntity>> updateReminder({
    required String id,
    String? title,
    String? description,
    DateTime? remindAt,
    bool? completed,
  });

  Future<Either<Failure, void>> deleteReminder(String id);
}
