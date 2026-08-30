import 'package:equatable/equatable.dart';

abstract class ApplicationDetailEvent extends Equatable {
  const ApplicationDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadApplicationDetailEvent extends ApplicationDetailEvent {
  final String id;
  const LoadApplicationDetailEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangeApplicationStatusEvent extends ApplicationDetailEvent {
  final String id;
  final String newStatus;
  final String? notes;

  const ChangeApplicationStatusEvent({
    required this.id,
    required this.newStatus,
    this.notes,
  });

  @override
  List<Object?> get props => [id, newStatus, notes];
}
