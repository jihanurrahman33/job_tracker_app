import '../../domain/entities/statistics_entity.dart';

class StatisticsModel extends StatisticsEntity {
  const StatisticsModel({
    required super.totalApplications,
    required super.byStatus,
    required super.responseRate,
    required super.interviewRate,
    required super.offerRate,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    final statusMap = <String, int>{};
    if (json['by_status'] is Map<String, dynamic>) {
      (json['by_status'] as Map<String, dynamic>).forEach((key, value) {
        if (value is num) {
          statusMap[key.toUpperCase()] = value.toInt();
        }
      });
    }

    return StatisticsModel(
      totalApplications: (json['total_applications'] as num?)?.toInt() ?? 0,
      byStatus: statusMap,
      responseRate: (json['response_rate'] as num?)?.toDouble() ?? 0.0,
      interviewRate: (json['interview_rate'] as num?)?.toDouble() ?? 0.0,
      offerRate: (json['offer_rate'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_applications': totalApplications,
      'by_status': byStatus,
      'response_rate': responseRate,
      'interview_rate': interviewRate,
      'offer_rate': offerRate,
    };
  }
}
