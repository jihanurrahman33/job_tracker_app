import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/reminder_entity.dart';
import '../repositories/reminder_repository.dart';

class GetRemindersUseCase implements UseCase<List<ReminderEntity>, NoParams> {
  final ReminderRepository repository;

  GetRemindersUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReminderEntity>>> call(NoParams params) {
    return repository.getReminders();
  }
}
