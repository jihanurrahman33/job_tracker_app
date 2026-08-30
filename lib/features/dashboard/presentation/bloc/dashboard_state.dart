import 'package:equatable/equatable.dart';
import '../../domain/entities/statistics_entity.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final StatisticsEntity? statistics;
  final String? errorMessage;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.statistics,
    this.errorMessage,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    StatisticsEntity? statistics,
    String? errorMessage,
  }) {
    return DashboardState(
      status: status ?? this.status,
      statistics: statistics ?? this.statistics,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, statistics, errorMessage];
}
