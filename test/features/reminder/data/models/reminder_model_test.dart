import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/reminder/data/models/reminder_model.dart';
import 'package:job_tracker/features/reminder/domain/entities/reminder_entity.dart';

void main() {
  group('ReminderModel JSON Serialization Tests', () {
    final tReminderModel = ReminderModel(
      id: 'rem_123',
      userId: 'user_123',
      applicationId: 'app_123',
      title: 'Follow up with recruiter',
      description: 'Ask about next steps',
      remindAt: DateTime.parse('2026-09-01T10:00:00.000Z'),
      completed: false,
      createdAt: DateTime.parse('2026-08-30T09:00:00.000Z'),
    );

    test('should be a subclass of ReminderEntity', () {
      expect(tReminderModel, isA<ReminderEntity>());
    });

    test('fromJson should parse reminder JSON', () {
      final jsonMap = {
        'id': 'rem_123',
        'user_id': 'user_123',
        'application_id': 'app_123',
        'title': 'Follow up with recruiter',
        'description': 'Ask about next steps',
        'remind_at': '2026-09-01T10:00:00.000Z',
        'completed': false,
        'created_at': '2026-08-30T09:00:00.000Z',
      };

      final result = ReminderModel.fromJson(jsonMap);

      expect(result.id, equals('rem_123'));
      expect(result.title, equals('Follow up with recruiter'));
      expect(result.completed, isFalse);
    });

    test('toJson should convert ReminderModel to map', () {
      final result = tReminderModel.toJson();

      expect(result['title'], equals('Follow up with recruiter'));
      expect(result['completed'], isFalse);
      expect(result['application_id'], equals('app_123'));
    });
  });
}
