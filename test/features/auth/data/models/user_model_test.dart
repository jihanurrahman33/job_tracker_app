import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/features/auth/data/models/user_model.dart';
import 'package:job_tracker/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserModel JSON Serialization Tests', () {
    final tUserModel = UserModel(
      id: 'user_123',
      email: 'john@example.com',
      name: 'John Doe',
      createdAt: DateTime.parse('2026-08-30T10:00:00.000Z'),
      updatedAt: DateTime.parse('2026-08-30T10:00:00.000Z'),
    );

    test('should be a subclass of UserEntity', () {
      expect(tUserModel, isA<UserEntity>());
    });

    test('fromJson should parse valid JSON object properly', () {
      final jsonMap = {
        'id': 'user_123',
        'email': 'john@example.com',
        'name': 'John Doe',
        'created_at': '2026-08-30T10:00:00.000Z',
        'updated_at': '2026-08-30T10:00:00.000Z',
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, equals('user_123'));
      expect(result.email, equals('john@example.com'));
      expect(result.name, equals('John Doe'));
      expect(result.createdAt, equals(DateTime.parse('2026-08-30T10:00:00.000Z')));
    });

    test('toJson should convert UserModel to JSON map', () {
      final result = tUserModel.toJson();

      expect(result['id'], equals('user_123'));
      expect(result['email'], equals('john@example.com'));
      expect(result['name'], equals('John Doe'));
      expect(result['created_at'], equals('2026-08-30T10:00:00.000Z'));
    });
  });
}
