import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_project/pages/setting.dart'; // ปรับให้ตรงกับเส้นทางไฟล์ของคุณ

void main() {
  testWidgets('การกดปุ่ม "เกี่ยวกับแอปพลิเคชัน" ควรแสดง Dialog ขึ้นมา',
      (WidgetTester tester) async {
    // สร้าง SettingsPage
    await tester.pumpWidget(
      const MaterialApp(
        home: SettingsPage(),
      ),
    );

    // ตรวจสอบว่าปุ่ม "เกี่ยวกับแอปพลิเคชัน" อยู่ในหน้าจอ
    expect(find.text('เกี่ยวกับแอปพลิเคชัน'), findsOneWidget);

    // กดปุ่ม "เกี่ยวกับแอปพลิเคชัน"
    await tester.tap(find.text('เกี่ยวกับแอปพลิเคชัน'));
    await tester.pumpAndSettle(
        const Duration(seconds: 3)); // ให้เวลาสำหรับการแสดง dialog

    // ตรวจสอบว่ามี Dialog แสดงขึ้นมา
    expect(find.byType(AlertDialog), findsOneWidget);

    // ตรวจสอบข้อความใน Dialog ว่าตรงตามที่คาดหวัง
    expect(find.text('เกี่ยวกับ'), findsOneWidget);
    expect(
        find.text(
            'ชื่อแอปพลิเคชัน: SU Map\nเวอร์ชัน: 1.0.0\nพัฒนาโดย: ทีมพัฒนา ABC'),
        findsOneWidget);

    // กดปุ่ม "ตกลง" ใน Dialog
    await tester.tap(find.text('ตกลง'));
    await tester.pumpAndSettle(
        const Duration(seconds: 3)); // ให้เวลาสำหรับการปิด dialog

    // ตรวจสอบว่า Dialog หายไป
    expect(find.byType(AlertDialog), findsNothing);
  });
}
