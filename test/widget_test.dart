// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

import 'package:vitrine/main.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Basic layout test (mobile device)', (WidgetTester tester) async {
    binding.window.physicalSizeTestValue = Size(400, 200);
    binding.window.devicePixelRatioTestValue = 1.0;
    // Build our app and trigger a frame.
    await tester.pumpWidget(new MyApp());
    // expect(find.byType(NavTabs), findsOneWidget);

    // resets the screen to its orinal size after the test end
    addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
  });
}
