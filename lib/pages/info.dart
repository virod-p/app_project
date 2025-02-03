import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FloorPlanPage extends StatefulWidget {
  final int floorNumber;

  const FloorPlanPage({super.key, required this.floorNumber});

  @override
  _FloorPlanPageState createState() => _FloorPlanPageState();
}

class _FloorPlanPageState extends State<FloorPlanPage> {
  List<Map<String, dynamic>> rooms = []; // เก็บข้อมูลห้อง

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    await Supabase.instance.client
        .from('floor${widget.floorNumber}')
        .select()
        .order('id', ascending: true)
        .then((data) {
      setState(() {
        rooms = List<Map<String, dynamic>>.from(data);
      });
    }).catchError((error) {
      print('Error fetching rooms: ${error.message}');
    });
  }

  Future<void> fetchRoomDetails(String roomName) async {
    await Supabase.instance.client
        .from(
            'floor${widget.floorNumber}') // เปลี่ยนเป็นชื่อ table ที่เก็บข้อมูลห้อง
        .select()
        .eq('name', roomName)
        .single()
        .then((response) {
      // ดึงข้อมูลห้องเมื่อพบ
      showRoomDetails(context, response);
    }).catchError((error) {
      print('Error fetching room details: ${error.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แผนผังชั้น ${widget.floorNumber}'),
      ),
      body: Stack(
        children: <Widget>[
          ...rooms.map((room) {
            return buildRoom(
              context,
              room['name'] ?? '',
              (room['left_'] ?? 0).toDouble(),
              (room['top'] ?? 0).toDouble(),
              (room['width'] ?? 100).toDouble(),
              (room['height'] ?? 100).toDouble(),
              Color(
                  int.parse('0xFF${room['color']?.substring(1) ?? 'FFFFFF'}')),
            );
          }),
        ],
      ),
    );
  }

  Widget buildRoom(BuildContext context, String roomName, double left,
      double top, double width, double height, Color color) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: roomName.isNotEmpty
            ? () {
                fetchRoomDetails(
                    roomName); // เรียกใช้ฟังก์ชันเพื่อดึงรายละเอียดห้อง
              }
            : null,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              roomName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void showRoomDetails(BuildContext context, Map<String, dynamic> roomDetails) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                roomDetails['name'] ?? '',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              roomDetails['image_url'] != null
                  ? Container(
                      width: double.infinity,
                      height: 150, // กำหนดความสูง
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(roomDetails['image_url']),
                          fit: BoxFit.cover, // ปรับขนาดรูปภาพ
                        ),
                      ),
                    )
                  : Container(), // แสดงรูปภาพห้องถ้ามี
              const SizedBox(height: 16),
              Text(
                'ชั้น: ${roomDetails['floor'] ?? ''}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'รายละเอียด: ${roomDetails['description'] ?? ''}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'เวลาเปิด-ปิด: ${roomDetails['time'] ?? ''}',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // ปิด modal
                },
                child: const Text('ปิด'),
              ),
            ],
          ),
        );
      },
    );
  }
}
