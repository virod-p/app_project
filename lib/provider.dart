import 'package:flutter/material.dart';

class FloorProvider with ChangeNotifier {
  List<bool> isPressed = List.generate(7, (index) => false);
  List<int> floorNumbers = List.generate(7, (index) => 7 - index);

  List<bool> rwtIsPressed = List.generate(2, (index) => false);
  List<int> rwtFloorNumbers = List.generate(2, (index) => 2 - index);

  void pressButton(int index) {
    isPressed[index] = true;
    notifyListeners(); // แจ้งให้หน้าอื่นอัปเดต
  }

  // ฟังก์ชันสำหรับรีเซ็ตสถานะการกด
  void resetPressedStatus() {
    isPressed = List.generate(7, (index) => false);
    notifyListeners(); // แจ้งให้หน้าอื่นอัปเดต
  }

  void rwtPressButton(int index) {
    rwtIsPressed[index] = true;
    notifyListeners(); // แจ้งให้หน้าอื่นอัปเดต
  }

  // ฟังก์ชันสำหรับรีเซ็ตสถานะการกด
  void rwtResetPressedStatus() {
    rwtIsPressed = List.generate(2, (index) => false);
    notifyListeners(); // แจ้งให้หน้าอื่นอัปเดต
  }
}
