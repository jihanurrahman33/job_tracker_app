import 'package:equatable/equatable.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();

  @override
  List<Object?> get props => [];
}

class LoadRemindersEvent extends ReminderEvent {
  final bool refresh;
  const LoadRemindersEvent({this.refresh = false});

  @override
  List<Object?> get props => [refresh];
}

class ToggleReminderStatusEvent extends ReminderEvent {
  final String id;
  final bool completed;

  const ToggleReminderStatusEvent({
    required this.id,
    required this.completed,
  });

  @override
  List<Object?> get props => [id, completed];
}

class DeleteReminderEvent extends ReminderEvent {
  final String id;
  const DeleteReminderEvent(this.id);

  @override
  List<Object?> get props => [id];
}
