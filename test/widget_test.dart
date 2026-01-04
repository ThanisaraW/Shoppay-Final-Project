import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shoppay/main.dart';

void main() {
  testWidgets('Shopee Clone app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that the app starts
    await tester.pumpAndSettle();

    // Verify that we can find the app
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}