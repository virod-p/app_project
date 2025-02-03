import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:app_project/main.dart';
import 'dart:convert';

class SUMapApp extends StatelessWidget {
  const SUMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SU Map',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const SUMapHomePage(),
    );
  }
}

class SUMapHomePage extends StatefulWidget {
  final buildingPlaceIdi;
  const SUMapHomePage({super.key, this.buildingPlaceIdi});

  @override
  SUMapHomePageState createState() => SUMapHomePageState();
}

class SUMapHomePageState extends State<SUMapHomePage> {
  final Set<Marker> _markers = {};

  // Place ID ของมหาวิทยาลัย
  static const String universityPlaceId =
      'ChIJGz0EsqH__DARx_9e4bIAyBg'; // Place ID ของมหาวิทยาลัย

  LatLng? initialCameraPosition; // เก็บพิกัดตำแหน่งของมหาวิทยาลัย
  double initialZoom = 16; // ค่า zoom เริ่มต้น

  @override
  void initState() {
    super.initState();
    _loadUniversityDetails(); // โหลดรายละเอียดมหาวิทยาลัย
  }

  Future<void> _loadUniversityDetails() async {
    // เรียกใช้ Google Places API เพื่อดึงข้อมูลมหาวิทยาลัย
    final universityDetails = await _getPlaceDetails(universityPlaceId);

    if (universityDetails != null) {
      setState(() {
        // กำหนดตำแหน่งกล้องไปยังมหาวิทยาลัย
        initialCameraPosition = LatLng(
          universityDetails['result']['geometry']['location']['lat'],
          universityDetails['result']['geometry']['location']['lng'],
        );

        // เพิ่ม Marker สำหรับมหาวิทยาลัย
        _markers.add(
          Marker(
            markerId: const MarkerId('university_marker'),
            position: initialCameraPosition!,
            infoWindow: InfoWindow(
              title: universityDetails['result']['name'],
              snippet: universityDetails['result']['vicinity'],
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed, // หมุดสีแดง
            ),
          ),
        );
      });
    }

    // เช็คว่า argument มีหรือไม่
    // ดึงค่า Place ID จาก widget.buildingPlaceIdi
    if (widget.buildingPlaceIdi != null) {
      final buildingDetails = await _getPlaceDetails(widget.buildingPlaceIdi!);

      if (buildingDetails != null) {
        setState(() {
          // เพิ่ม Marker สำหรับอาคาร
          _markers.add(
            Marker(
              markerId: const MarkerId('building_marker'),
              position: LatLng(
                buildingDetails['result']['geometry']['location']['lat'],
                buildingDetails['result']['geometry']['location']['lng'],
              ),
              infoWindow: InfoWindow(
                title: buildingDetails['result']['name'],
                snippet: buildingDetails['result']['vicinity'],
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue, // หมุดสีน้ำเงินสำหรับอาคาร
              ),
            ),
          );

          // เปลี่ยนตำแหน่งกล้องไปที่อาคาร
          initialCameraPosition = LatLng(
            buildingDetails['result']['geometry']['location']['lat'],
            buildingDetails['result']['geometry']['location']['lng'],
          );

          // เปลี่ยนค่า zoom เป็น 17 หากมี Place ID
          initialZoom = 17;

          // เรียกใช้ animateCamera เพื่อเลื่อนกล้องไปที่ตำแหน่งอาคาร
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: initialCameraPosition!,
                zoom: initialZoom,
              ),
            ),
          );
        });
      }
    }
  }

  Future<Map<String, dynamic>?> _getPlaceDetails(String placeId) async {
    const apiKey =
        'AIzaSyDZr2kKyRq8_ZXUaIYEN39aaw3sOsSqv6A'; // ใส่ API Key ของคุณที่นี่
    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SU Map',
            style: TextStyle(color: Colors.white, fontSize: 24)),
        backgroundColor: Colors.teal,
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: initialCameraPosition == null
          ? const Center(child: CircularProgressIndicator()) // รอข้อมูลสถานที่
          : GoogleMap(
              onMapCreated: (controller) {
                googleMapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: initialCameraPosition!, // ตำแหน่งกล้องที่โหลดจาก API
                zoom: initialZoom, // กำหนด zoom ตามค่า initialZoom
              ),
              markers: _markers, // แสดง Marker บนแผนที่
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
            ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(128, 255, 255, 255),
        currentIndex: 1,
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
              backgroundColor: Color.fromARGB(255, 0, 150, 136)),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
