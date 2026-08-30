import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/either.dart';
import '../entities/reminder_entity.dart';
import '../repositories/reminder_repository.dart';

class CreateReminderParams extends Equatable {
  final String? applicationId;
  final String title;
  final String? description;
  final DateTime remindAt;

  const CreateReminderParams({
    this.applicationId,
    required this.title,
    this.description,
    required this.remindAt,
  });

  @override
  List<Object?> get props => [applicationId, title, description, remindAt];
}

class CreateReminderUseCase
    implements UseCase<ReminderEntity, CreateReminderParams> {
  final ReminderRepository repository;

  CreateReminderUseCase(this.repository);

  @override
  Future<Either<Failure, ReminderEntity>> call(CreateReminderParams params) {
    return repository.createReminder(
      applicationId: params.applicationId,
      title: params.title,
      description: params.description,
      remindAt: params.remindAt,
    );
  }
}
