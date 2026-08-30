import '../../domain/entities/interview_entity.dart';

class InterviewModel extends InterviewEntity {
  const InterviewModel({
    required super.id,
    required super.applicationId,
    required super.type,
    required super.scheduledAt,
    required super.durationMinutes,
    super.location,
    super.meetingUrl,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory InterviewModel.fromJson(Map<String, dynamic> json) {
    return InterviewModel(
      id: json['id'] as String? ?? '',
      applicationId: json['application_id'] as String? ?? '',
      type: json['type'] as String? ?? 'OTHER',
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 45,
      location: json['location'] as String?,
      meetingUrl: json['meeting_url'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'type': type,
      'scheduled_at': scheduledAt.toUtc().toIso8601String(),
      'duration_minutes': durationMinutes,
    };

    if (location != null) map['location'] = location;
    if (meetingUrl != null) map['meeting_url'] = meetingUrl;
    if (notes != null) map['notes'] = notes;

    return map;
  }
}
