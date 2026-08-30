import 'package:equatable/equatable.dart';
import '../../domain/entities/application_entity.dart';
import '../../domain/entities/application_event_entity.dart';

enum ApplicationDetailStatus { initial, loading, loaded, updating, error }

class ApplicationDetailState extends Equatable {
  final ApplicationDetailStatus status;
  final ApplicationEntity? application;
  final List<ApplicationEventEntity> events;
  final String? errorMessage;

  const ApplicationDetailState({
    this.status = ApplicationDetailStatus.initial,
    this.application,
    this.events = const [],
    this.errorMessage,
  });

  ApplicationDetailState copyWith({
    ApplicationDetailStatus? status,
    ApplicationEntity? application,
    List<ApplicationEventEntity>? events,
    String? errorMessage,
  }) {
    return ApplicationDetailState(
      status: status ?? this.status,
      application: application ?? this.application,
      events: events ?? this.events,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, application, events, errorMessage];
}
