// new by do
// API
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Pages
import 'pages/start.dart';
import 'pages/home.dart';
import 'pages/floor.dart';
import 'pages/rwtfloor.dart';
import 'pages/info.dart';
import 'pages/rwtinfo.dart';
import 'pages/map.dart';
import 'pages/calendar.dart';
import 'pages/setting.dart';
import 'provider.dart';

late GoogleMapController googleMapController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: '',
    anonKey: '',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FloorProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Define the initial route
      onGenerateRoute: (settings) {
        if (settings.name == '/info') {
          final args =
              settings.arguments as int; // รับเลขชั้นที่ส่งมาจาก arguments
          return MaterialPageRoute(
            builder: (context) {
              return FloorPlanPage(
                  floorNumber: args); // ส่งเลขชั้นไปยังหน้า FloorPlanPage
            },
          );
        }
        if (settings.name == '/rwtinfo') {
          final args =
              settings.arguments as int; // รับเลขชั้นที่ส่งมาจาก arguments
          return MaterialPageRoute(
            builder: (context) {
              return RWTFloorPlanPage(
                  floorNumber: args); // ส่งเลขชั้นไปยังหน้า FloorPlanPage
            },
          );
        }
        if (settings.name == '/map') {
          if (settings.arguments != null) {
            final args =
                settings.arguments as String; // รับเลขชั้นที่ส่งมาจาก arguments
            return MaterialPageRoute(
              builder: (context) {
                return SUMapHomePage(
                    buildingPlaceIdi:
                        args); // ส่งเลขชั้นไปยังหน้า FloorPlanPage
              },
            );
          }
        }
        // ส่วน route อื่นๆ
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => StartPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomePage());
          // case '/rwtinfo':
          //   return MaterialPageRoute(
          //       builder: (context) => const RWTFloorPlanPage());
          case '/floor':
            return MaterialPageRoute(builder: (context) => FloorPage());
          case '/rwtfloor':
            return MaterialPageRoute(
                builder: (context) => const RWTFloorPage());
          case '/map':
            return MaterialPageRoute(
                builder: (context) => const SUMapHomePage());
          case '/calendar':
            return MaterialPageRoute(
                builder: (context) => const CalendarPage());
          case '/settings':
            return MaterialPageRoute(
                builder: (context) => const SettingsPage());
          default:
            return null;
        }
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late GoogleMapController mapController;

//   final LatLng _center = const LatLng(13.8190983, 100.0411886);

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.green[700],
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Maps Sample App'),
//           elevation: 2,
//         ),
//         body: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: _center,
//             zoom: 11.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
