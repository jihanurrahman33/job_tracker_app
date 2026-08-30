import '../../domain/entities/reminder_entity.dart';

class ReminderModel extends ReminderEntity {
  const ReminderModel({
    required super.id,
    required super.userId,
    super.applicationId,
    required super.title,
    super.description,
    required super.remindAt,
    required super.completed,
    required super.createdAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      applicationId: json['application_id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      remindAt: json['remind_at'] != null
          ? DateTime.tryParse(json['remind_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      completed: json['completed'] as bool? ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'title': title,
      'remind_at': remindAt.toUtc().toIso8601String(),
      'completed': completed,
    };

    if (applicationId != null) map['application_id'] = applicationId;
    if (description != null) map['description'] = description;

    return map;
  }
}
