import 'package:equatable/equatable.dart';

class ApplicationEventEntity extends Equatable {
  final String id;
  final String applicationId;
  final String? fromStatus;
  final String toStatus;
  final String? notes;
  final DateTime createdAt;

  const ApplicationEventEntity({
    required this.id,
    required this.applicationId,
    this.fromStatus,
    required this.toStatus,
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        applicationId,
        fromStatus,
        toStatus,
        notes,
        createdAt,
      ];
}
