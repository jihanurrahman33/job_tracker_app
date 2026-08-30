import 'package:flutter_test/flutter_test.dart';
import 'package:job_tracker/core/widgets/status_badge.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App widget smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatusBadge(status: 'APPLIED'),
        ),
      ),
    );

    expect(find.text('Applied'), findsOneWidget);
  });
}
