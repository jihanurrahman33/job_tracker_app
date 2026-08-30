import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/dashboard/data/models/statistics_model.dart';
import 'package:job_tracker/features/dashboard/domain/entities/statistics_entity.dart';

void main() {
  group('StatisticsModel JSON Serialization Tests', () {
    const tStatsModel = StatisticsModel(
      totalApplications: 12,
      byStatus: {
        'APPLIED': 3,
        'SCREENING': 2,
        'INTERVIEW': 1,
        'TECHNICAL_INTERVIEW': 2,
        'OFFER': 1,
        'REJECTED': 2,
        'WITHDRAWN': 1,
        'ACCEPTED': 0,
      },
      responseRate: 0.67,
      interviewRate: 0.25,
      offerRate: 0.08,
    );

    test('should be a subclass of StatisticsEntity', () {
      expect(tStatsModel, isA<StatisticsEntity>());
    });

    test('fromJson should parse statistics JSON accurately', () {
      final jsonMap = {
        'total_applications': 12,
        'by_status': {
          'APPLIED': 3,
          'SCREENING': 2,
          'INTERVIEW': 1,
          'TECHNICAL_INTERVIEW': 2,
          'OFFER': 1,
          'REJECTED': 2,
          'WITHDRAWN': 1,
          'ACCEPTED': 0,
        },
        'response_rate': 0.67,
        'interview_rate': 0.25,
        'offer_rate': 0.08,
      };

      final result = StatisticsModel.fromJson(jsonMap);

      expect(result.totalApplications, equals(12));
      expect(result.responseRate, equals(0.67));
      expect(result.responseRatePercent, equals('67.0%'));
      expect(result.interviewRatePercent, equals('25.0%'));
      expect(result.offerRatePercent, equals('8.0%'));
      expect(result.countForStatus('APPLIED'), equals(3));
    });

    test('toJson should convert StatisticsModel to map', () {
      final result = tStatsModel.toJson();

      expect(result['total_applications'], equals(12));
      expect(result['response_rate'], equals(0.67));
    });
  });
}
