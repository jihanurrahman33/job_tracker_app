import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/reminder_entity.dart';
import '../repositories/reminder_repository.dart';

class UpdateReminderParams extends Equatable {
  final String id;
  final String? title;
  final String? description;
  final DateTime? remindAt;
  final bool? completed;

  const UpdateReminderParams({
    required this.id,
    this.title,
    this.description,
    this.remindAt,
    this.completed,
  });

  @override
  List<Object?> get props => [id, title, description, remindAt, completed];
}

class UpdateReminderUseCase
    implements UseCase<ReminderEntity, UpdateReminderParams> {
  final ReminderRepository repository;

  UpdateReminderUseCase(this.repository);

  @override
  Future<Either<Failure, ReminderEntity>> call(UpdateReminderParams params) {
    return repository.updateReminder(
      id: params.id,
      title: params.title,
      description: params.description,
      remindAt: params.remindAt,
      completed: params.completed,
    );
  }
}
