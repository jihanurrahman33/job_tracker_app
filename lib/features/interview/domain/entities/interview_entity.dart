import 'package:equatable/equatable.dart';

class InterviewEntity extends Equatable {
  final String id;
  final String applicationId;
  final String type;
  final DateTime scheduledAt;
  final int durationMinutes;
  final String? location;
  final String? meetingUrl;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const InterviewEntity({
    required this.id,
    required this.applicationId,
    required this.type,
    required this.scheduledAt,
    required this.durationMinutes,
    this.location,
    this.meetingUrl,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedDuration => '$durationMinutes mins';

  @override
  List<Object?> get props => [
        id,
        applicationId,
        type,
        scheduledAt,
        durationMinutes,
        location,
        meetingUrl,
        notes,
        createdAt,
        updatedAt,
      ];
}
