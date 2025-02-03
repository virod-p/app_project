import 'dart:math';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _events = []; // เก็บข้อมูลกิจกรรมจาก Supabase
  Map<DateTime, List<Map<String, dynamic>>> _eventsByDate = {};
  final Map<DateTime, Color> _eventColors = {}; // เก็บสีสุ่มสำหรับแต่ละวัน

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  // ดึงข้อมูลจาก Supabase
  Future<void> _fetchEvents() async {
    Supabase.instance.client
        .from('activity') // ชื่อตารางใน Supabase
        .select()
        .order('date', ascending: true)
        .then((response) {
      setState(() {
        _events = List<Map<String, dynamic>>.from(response);
        _groupEventsByDate();
      });
    }).catchError((error) {
      print('Error fetching events: $error');
    });
  }

  // จัดกลุ่มกิจกรรมตามวันที่และสร้างสีสุ่มสำหรับแต่ละวัน
  void _groupEventsByDate() {
    for (var event in _events) {
      final eventDate = DateTime.parse(event['date']);
      if (!_eventsByDate.containsKey(eventDate)) {
        _eventsByDate[eventDate] = [];
        _eventColors[eventDate] = _getRandomColor(); // สร้างสีสุ่ม
      }
      _eventsByDate[eventDate]!.add(event);
    }
  }

  // สร้างสีแบบสุ่ม
  Color _getRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            // ปรับแต่งสีของวันในปฏิทินตามกิจกรรม
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final dayWithoutTime = DateTime(day.year, day.month, day.day);

                if (_eventsByDate.containsKey(dayWithoutTime)) {
                  return Container(
                    decoration: BoxDecoration(
                      color: _eventColors[dayWithoutTime]!,
                      shape: BoxShape.circle,
                    ),
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                return null;
              },
              selectedBuilder: (context, day, focusedDay) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.blue,
                        width: 2), // เปลี่ยนกรอบเป็นสีน้ำเงิน
                    shape: BoxShape.circle,
                  ),
                  margin: const EdgeInsets.all(6.0),
                  alignment: Alignment.center,
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                final eventDate = DateTime.parse(event['date']);

                // แสดงเฉพาะกิจกรรมในเดือนที่ผู้ใช้กำลังดู
                if (eventDate.month != _focusedDay.month) {
                  return const SizedBox
                      .shrink(); // ซ่อนกิจกรรมที่ไม่ใช่ของเดือนปัจจุบัน
                }

                final eventName = event['name'];
                final eventLocation = event['location'];
                final eventTime = event['time'];
                final eventColor = _eventColors[DateTime(
                        eventDate.year, eventDate.month, eventDate.day)] ??
                    Colors.grey;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: eventColor,
                    child:
                        Text('${eventDate.day}'), // แสดงเฉพาะวันที่ (เช่น 31)
                  ),
                  title: Text(eventName),
                  subtitle: Text('$eventLocation - $eventTime'),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(128, 255, 255, 255),
        currentIndex: 2,
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
              backgroundColor: Color.fromARGB(255, 0, 150, 136)),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันที่ทำงานเมื่อกดที่กิจกรรมใน ListView
  void _onEventTap(Map<String, dynamic> event) {
    final eventDate = DateTime.parse(event['date']);
    setState(() {
      _selectedDay = eventDate;
      _focusedDay = eventDate;
    });
  }
}
