// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:labor_app_frontend/main.dart';

void main() {
  testWidgets('App shows login screen by default', (WidgetTester tester) async {
    await tester.pumpWidget(const LaborApp());

    expect(find.text('Login'), findsAtLeastNWidgets(1));
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
  });
}
