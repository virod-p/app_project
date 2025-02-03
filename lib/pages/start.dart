import 'dart:async';
import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage>
    with SingleTickerProviderStateMixin {
  double _opacity = 1.0; // เริ่มต้นค่า opacity ที่ 1 (แสดงผลเต็ม)
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // สร้าง AnimationController สำหรับจัดการ animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 1), // ระยะเวลาในการจาง (2 วินาที)
    );

    // เริ่มต้นดีเลย์ 3 วินาที และจางภาพจากนั้น
    Timer(Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0; // เมื่อครบ 3 วินาที ให้ทำการจาง
      });

      // เริ่มการจาง
      _controller.forward();

      // เมื่อจางเสร็จสิ้น ให้เปลี่ยนไปยังหน้าถัดไป
      Timer(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, '/home'); // เปลี่ยนไปหน้าถัดไป
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity, // กำหนดค่า opacity ที่จะใช้
        duration: Duration(seconds: 1), // ระยะเวลาในการเปลี่ยนแปลงค่า opacity
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter, // ไล่สีจากบนลงล่าง
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0477A5), // ฟ้าเข้ม
                Color(0xFF68D0C0), // ฟ้าอ่อน
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logoApp.png', // ไฟล์โลโก้
                  height: 600, // ปรับความสูงของโลโก้
                  width: 600, // ปรับความกว้างของโลโก้
                  // fit: BoxFit.contain, // (ไม่จำเป็น) ให้ขยายหรือย่อภาพรักษาสัดส่วน
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
