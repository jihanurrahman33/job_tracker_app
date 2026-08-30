import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/application/data/models/application_model.dart';
import 'package:job_tracker/features/application/domain/entities/application_entity.dart';

void main() {
  group('ApplicationModel JSON Serialization Tests', () {
    final tApplicationModel = ApplicationModel(
      id: 'app_123',
      userId: 'user_123',
      company: 'Stripe',
      position: 'Backend Engineer',
      location: 'Remote',
      jobUrl: 'https://jobs.stripe.com/backend-engineer',
      salaryMin: 140000,
      salaryMax: 180000,
      salaryCurrency: 'USD',
      status: 'APPLIED',
      appliedAt: DateTime.parse('2026-08-28T09:30:00.000Z'),
      notes: 'Submitted via referral',
      createdAt: DateTime.parse('2026-08-28T09:30:00.000Z'),
      updatedAt: DateTime.parse('2026-08-28T09:30:00.000Z'),
    );

    test('should be a subclass of ApplicationEntity', () {
      expect(tApplicationModel, isA<ApplicationEntity>());
    });

    test('fromJson should parse application JSON correctly', () {
      final jsonMap = {
        'id': 'app_123',
        'user_id': 'user_123',
        'company': 'Stripe',
        'position': 'Backend Engineer',
        'location': 'Remote',
        'job_url': 'https://jobs.stripe.com/backend-engineer',
        'salary_min': 140000,
        'salary_max': 180000,
        'salary_currency': 'USD',
        'status': 'APPLIED',
        'applied_at': '2026-08-28T09:30:00.000Z',
        'notes': 'Submitted via referral',
        'created_at': '2026-08-28T09:30:00.000Z',
        'updated_at': '2026-08-28T09:30:00.000Z',
      };

      final result = ApplicationModel.fromJson(jsonMap);

      expect(result.id, equals('app_123'));
      expect(result.company, equals('Stripe'));
      expect(result.position, equals('Backend Engineer'));
      expect(result.salaryMin, equals(140000));
      expect(result.status, equals('APPLIED'));
    });

    test('formattedSalary should output clean range', () {
      expect(tApplicationModel.formattedSalary, equals('USD 140k - 180k'));
    });

    test('toJson should convert ApplicationModel to map', () {
      final result = tApplicationModel.toJson();

      expect(result['company'], equals('Stripe'));
      expect(result['position'], equals('Backend Engineer'));
      expect(result['status'], equals('APPLIED'));
      expect(result['salary_min'], equals(140000));
      expect(result['salary_currency'], equals('USD'));
    });
  });
}
