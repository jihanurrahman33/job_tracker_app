import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/interview/data/models/interview_model.dart';
import 'package:job_tracker/features/interview/domain/entities/interview_entity.dart';

void main() {
  group('InterviewModel JSON Serialization Tests', () {
    final tInterviewModel = InterviewModel(
      id: 'int_123',
      applicationId: 'app_123',
      type: 'TECHNICAL',
      scheduledAt: DateTime.parse('2026-09-15T14:00:00.000Z'),
      durationMinutes: 45,
      location: 'Zoom',
      meetingUrl: 'https://zoom.us/j/123456',
      notes: 'Coding round',
      createdAt: DateTime.parse('2026-08-29T07:00:00.000Z'),
      updatedAt: DateTime.parse('2026-08-29T07:00:00.000Z'),
    );

    test('should be a subclass of InterviewEntity', () {
      expect(tInterviewModel, isA<InterviewEntity>());
    });

    test('fromJson should parse interview JSON', () {
      final jsonMap = {
        'id': 'int_123',
        'application_id': 'app_123',
        'type': 'TECHNICAL',
        'scheduled_at': '2026-09-15T14:00:00.000Z',
        'duration_minutes': 45,
        'location': 'Zoom',
        'meeting_url': 'https://zoom.us/j/123456',
        'notes': 'Coding round',
        'created_at': '2026-08-29T07:00:00.000Z',
        'updated_at': '2026-08-29T07:00:00.000Z',
      };

      final result = InterviewModel.fromJson(jsonMap);

      expect(result.id, equals('int_123'));
      expect(result.type, equals('TECHNICAL'));
      expect(result.durationMinutes, equals(45));
      expect(result.meetingUrl, equals('https://zoom.us/j/123456'));
    });

    test('toJson should convert InterviewModel to map', () {
      final result = tInterviewModel.toJson();

      expect(result['type'], equals('TECHNICAL'));
      expect(result['duration_minutes'], equals(45));
      expect(result['meeting_url'], equals('https://zoom.us/j/123456'));
    });
  });
}
