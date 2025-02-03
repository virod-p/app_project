import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_project/pages/home.dart';

void main() {
  testWidgets('ตรวจสอบการทำงานของปุ่ม นำทาง', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const HomePage(),
      routes: {
        '/map': (context) => const Scaffold(body: Text('Map Page')),
      },
    ));

    // กดปุ่มนำทาง
    await tester.tap(find.text('นำทาง').first);
    await tester.pumpAndSettle();

    // ตรวจสอบว่าถูกนำไปที่หน้า Map Page
    expect(find.text('Map Page'), findsOneWidget);
  });

  testWidgets('ตรวจสอบการทำงานของปุ่ม แผนผังอาคาร',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: const HomePage(),
      routes: {
        '/floor': (context) => const Scaffold(body: Text('Floor Page')),
      },
    ));

    // ปุ่มแผนผังอาคาร
    await tester.tap(find.text('แผนผังอาคาร').first);
    await tester.pumpAndSettle();

    // ตรวจสอบว่าถูกนำไปที่หน้า Floor
    expect(find.text('Floor Page'), findsOneWidget);
  });
}
