import 'package:equatable/equatable.dart';

class ReminderEntity extends Equatable {
  final String id;
  final String userId;
  final String? applicationId;
  final String title;
  final String? description;
  final DateTime remindAt;
  final bool completed;
  final DateTime createdAt;

  const ReminderEntity({
    required this.id,
    required this.userId,
    this.applicationId,
    required this.title,
    this.description,
    required this.remindAt,
    required this.completed,
    required this.createdAt,
  });

  bool get isOverdue => !completed && remindAt.isBefore(DateTime.now());

  @override
  List<Object?> get props => [
        id,
        userId,
        applicationId,
        title,
        description,
        remindAt,
        completed,
        createdAt,
      ];
}
