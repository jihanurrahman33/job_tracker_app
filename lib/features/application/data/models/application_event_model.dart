import '../../domain/entities/application_event_entity.dart';

class ApplicationEventModel extends ApplicationEventEntity {
  const ApplicationEventModel({
    required super.id,
    required super.applicationId,
    super.fromStatus,
    required super.toStatus,
    super.notes,
    required super.createdAt,
  });

  factory ApplicationEventModel.fromJson(Map<String, dynamic> json) {
    return ApplicationEventModel(
      id: json['id'] as String? ?? '',
      applicationId: json['application_id'] as String? ?? '',
      fromStatus: json['from_status'] as String?,
      toStatus: json['to_status'] as String? ?? 'APPLIED',
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'id': id,
      'application_id': applicationId,
      'to_status': toStatus,
      'created_at': createdAt.toUtc().toIso8601String(),
    };

    if (fromStatus != null) map['from_status'] = fromStatus;
    if (notes != null) map['notes'] = notes;

    return map;
  }
}
