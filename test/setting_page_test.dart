import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_project/pages/setting.dart';

//ตรวจสอบว่า widget ต่างๆแสดงผลถูกต้องไหม
void main() {
  testWidgets('SettingsPage renders correctly', (WidgetTester tester) async {
    // สร้าง widget SettingsPage ขึ้นมา
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsPage(),
      ),
    );

    // ตรวจสอบว่า AppBar มีข้อความ 'Setting'
    final appBar = find.byType(AppBar); // ค้นหา AppBar ก่อน
    expect(find.descendant(of: appBar, matching: find.text('Setting')),
        findsOneWidget);

    // ตรวจสอบว่ามี toggle ปุ่มภาษา 2 ปุ่ม (ไทย, English)
    expect(find.text('ไทย'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    // ตรวจสอบว่ามีปุ่มเกี่ยวกับแอปพลิเคชัน
    expect(find.text('เกี่ยวกับแอปพลิเคชัน'), findsOneWidget);
  });
}
