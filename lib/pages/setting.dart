import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // กำหนด state สำหรับปุ่ม toggle ภาษา
  List<bool> isSelected = [true, false]; // ตัวอย่าง: ค่าเริ่มต้นภาษาไทยถูกเลือก

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: const SizedBox(), // Empty to leave space like iPhone notch
      ),
      body: ListView(
        children: [
          // ปุ่มเกี่ยวกับแอปพลิเคชัน
          ListTile(
            title: const Text('เกี่ยวกับแอปพลิเคชัน'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('เกี่ยวกับ'),
                    content: const Text(
                      'ชื่อแอปพลิเคชัน: SU Map\nเวอร์ชัน: 1.0.0\nพัฒนาโดย: ทีมพัฒนา ABC',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('ตกลง'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // ปุ่มภาษา (toggle ภาษา)
          ListTile(
            title: const Text('ภาษา'),
            trailing: ToggleButtons(
              isSelected: isSelected, // ใช้ state ที่สร้างไว้
              selectedColor: Colors.white,
              color: Colors.grey,
              fillColor: Colors.teal,
              borderRadius: BorderRadius.circular(15),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('ไทย'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('English'),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  // อัปเดต state เมื่อกดเปลี่ยนภาษา
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                });
              },
            ),
          ),
          // ปุ่มการแจ้งเตือน
          ListTile(
            title: const Text('การแจ้งเตือน'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('การแจ้งเตือน'),
                    content: const Text(
                      'คุณสามารถเปิดหรือปิดการแจ้งเตือนของแอปพลิเคชันได้ในหน้าการตั้งค่า',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('ตกลง'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          // ปุ่มติดต่อ
          ListTile(
            title: const Text('ติดต่อ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('ติดต่อ'),
                    content: const Text(
                      'คุณสามารถติดต่อทีมพัฒนาได้ที่: \nEmail: support@myapp.com\nโทร: 123-456-7890',
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('ตกลง'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(128, 255, 255, 255),
        currentIndex: 3, // Set the index for settings
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/map');
              break;
            case 2:
              Navigator.pushNamed(context, '/calendar');
              break;
            case 3:
              Navigator.pushNamed(context, '/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
              backgroundColor: Color.fromARGB(255, 0, 150, 136)),
        ],
      ),
    );
  }
}
