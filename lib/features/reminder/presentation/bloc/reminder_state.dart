import 'package:equatable/equatable.dart';
import '../../domain/entities/reminder_entity.dart';

enum ReminderStatus { initial, loading, loaded, error }

class ReminderState extends Equatable {
  final ReminderStatus status;
  final List<ReminderEntity> reminders;
  final String? errorMessage;

  const ReminderState({
    this.status = ReminderStatus.initial,
    this.reminders = const [],
    this.errorMessage,
  });

  List<ReminderEntity> get pendingReminders =>
      reminders.where((r) => !r.completed).toList();

  List<ReminderEntity> get completedReminders =>
      reminders.where((r) => r.completed).toList();

  ReminderState copyWith({
    ReminderStatus? status,
    List<ReminderEntity>? reminders,
    String? errorMessage,
  }) {
    return ReminderState(
      status: status ?? this.status,
      reminders: reminders ?? this.reminders,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, reminders, errorMessage];
}
