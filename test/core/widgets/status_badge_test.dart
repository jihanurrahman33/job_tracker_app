import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/core/widgets/status_badge.dart';

void main() {
  group('StatusBadge Widget Tests', () {
    testWidgets('renders application status in title case correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: 'TECHNICAL_INTERVIEW'),
          ),
        ),
      );

      expect(find.text('Technical Interview'), findsOneWidget);
    });

    testWidgets('renders interview type badge correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatusBadge(status: 'PHONE_SCREEN', isInterviewType: true),
          ),
        ),
      );

      expect(find.text('Phone Screen'), findsOneWidget);
    });
  });
}
