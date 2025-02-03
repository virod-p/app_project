import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_project/provider.dart';

class RWTFloorPage extends StatelessWidget {
  const RWTFloorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final floorProvider = Provider.of<FloorProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        // รีเซ็ตสถานะปุ่มเมื่อออกจากหน้านี้
        floorProvider.rwtResetPressedStatus();
        return true; // อนุญาตให้ย้อนกลับ
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('เลือกชั้นของตึก'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(2, (index) {
              int floorNumber = floorProvider.rwtFloorNumbers[index];
              return GestureDetector(
                onTap: () {
                  floorProvider.rwtPressButton(index);
                  Navigator.pushNamed(
                    context,
                    '/rwtinfo',
                    arguments: floorNumber,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 2.0),
                  width: 200,
                  height: 60,
                  decoration: BoxDecoration(
                    color: floorProvider.rwtIsPressed[index]
                        ? Colors.green[300]
                        : Colors.green[800],
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      'ชั้นที่ $floorNumber',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
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
