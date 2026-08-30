import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../repositories/reminder_repository.dart';

class DeleteReminderParams extends Equatable {
  final String id;
  const DeleteReminderParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteReminderUseCase implements UseCase<void, DeleteReminderParams> {
  final ReminderRepository repository;

  DeleteReminderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteReminderParams params) {
    return repository.deleteReminder(params.id);
  }
}
