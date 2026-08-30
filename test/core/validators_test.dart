import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/core/utils/validators.dart';

void main() {
  group('Validators Tests', () {
    test('requiredField should validate non-empty string', () {
      expect(Validators.requiredField(null), isNotNull);
      expect(Validators.requiredField(''), isNotNull);
      expect(Validators.requiredField('   '), isNotNull);
      expect(Validators.requiredField('Valid text'), isNull);
    });

    test('email should validate correctly', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email('invalid-email'), isNotNull);
      expect(Validators.email('test@'), isNotNull);
      expect(Validators.email('test@example.com'), isNull);
      expect(Validators.email('john.doe@company.co.uk'), isNull);
    });

    test('password should enforce minimum length', () {
      expect(Validators.password(null), isNotNull);
      expect(Validators.password('12345', minLength: 6), isNotNull);
      expect(Validators.password('123456', minLength: 6), isNull);
      expect(Validators.password('strongpassword123', minLength: 6), isNull);
    });

    test('url should validate HTTP/HTTPS urls', () {
      expect(Validators.url('not a url'), isNotNull);
      expect(Validators.url('ftp://ftp.is.co.za'), isNotNull);
      expect(Validators.url('https://example.com/job/123'), isNull);
      expect(Validators.url('http://localhost:8080'), isNull);
      expect(Validators.url(''), isNull);
      expect(Validators.url(null), isNull);
    });

    test('number validator should validate numeric strings', () {
      expect(Validators.number('abc'), isNotNull);
      expect(Validators.number('-50'), isNotNull);
      expect(Validators.number('150000'), isNull);
      expect(Validators.number('0'), isNull);
      expect(Validators.number(''), isNull);
    });
  });
}
