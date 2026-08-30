import 'package:equatable/equatable.dart';
import '../../domain/entities/interview_entity.dart';

enum InterviewListStatus { initial, loading, loaded, error }

class InterviewState extends Equatable {
  final InterviewListStatus status;
  final List<InterviewEntity> interviews;
  final String? errorMessage;

  const InterviewState({
    this.status = InterviewListStatus.initial,
    this.interviews = const [],
    this.errorMessage,
  });

  InterviewState copyWith({
    InterviewListStatus? status,
    List<InterviewEntity>? interviews,
    String? errorMessage,
  }) {
    return InterviewState(
      status: status ?? this.status,
      interviews: interviews ?? this.interviews,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, interviews, errorMessage];
}
