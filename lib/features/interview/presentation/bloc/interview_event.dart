import 'package:equatable/equatable.dart';

abstract class InterviewEvent extends Equatable {
  const InterviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadInterviewsForAppEvent extends InterviewEvent {
  final String applicationId;
  const LoadInterviewsForAppEvent(this.applicationId);

  @override
  List<Object?> get props => [applicationId];
}

class DeleteInterviewItemEvent extends InterviewEvent {
  final String id;
  final String applicationId;

  const DeleteInterviewItemEvent({
    required this.id,
    required this.applicationId,
  });

  @override
  List<Object?> get props => [id, applicationId];
}
