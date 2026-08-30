import 'package:equatable/equatable.dart';

class StatisticsEntity extends Equatable {
  final int totalApplications;
  final Map<String, int> byStatus;
  final double responseRate;
  final double interviewRate;
  final double offerRate;

  const StatisticsEntity({
    required this.totalApplications,
    required this.byStatus,
    required this.responseRate,
    required this.interviewRate,
    required this.offerRate,
  });

  int countForStatus(String status) => byStatus[status.toUpperCase()] ?? 0;

  String get responseRatePercent => '${(responseRate * 100).toStringAsFixed(1)}%';
  String get interviewRatePercent => '${(interviewRate * 100).toStringAsFixed(1)}%';
  String get offerRatePercent => '${(offerRate * 100).toStringAsFixed(1)}%';

  @override
  List<Object?> get props => [
        totalApplications,
        byStatus,
        responseRate,
        interviewRate,
        offerRate,
      ];
}
