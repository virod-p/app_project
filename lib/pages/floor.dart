import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_project/provider.dart';

class FloorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final floorProvider = Provider.of<FloorProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // รีเซ็ตสถานะปุ่มเมื่อออกจากหน้านี้
        floorProvider.resetPressedStatus();
        return true; // อนุญาตให้ย้อนกลับ
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('เลือกชั้นของตึก'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(7, (index) {
              int floorNumber = floorProvider.floorNumbers[index];
              return GestureDetector(
                onTap: () {
                  floorProvider.pressButton(index);
                  Navigator.pushNamed(
                    context,
                    '/info',
                    arguments: floorNumber, // ส่งเลขชั้นไป
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 2.0),
                  width: 200,
                  height: 60,
                  decoration: BoxDecoration(
                    color: floorProvider.isPressed[index]
                        ? Colors.green[300]
                        : Colors.green[800],
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'ชั้นที่ $floorNumber',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
