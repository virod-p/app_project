import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_project/pages/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock SharedPreferences
  SharedPreferences.setMockInitialValues({});

  // Use setUp to initialize Supabase before each test
  setUp(() async {
    await Supabase.initialize(
      url: '',
      anonKey: '',
    );
  });

  testWidgets('CalendarPage displays calendar', (WidgetTester tester) async {
    // Build the CalendarPage
    await tester.pumpWidget(const MaterialApp(home: CalendarPage()));

    // Wait for Calendar to load
    await tester.pumpAndSettle();

    // Check if TableCalendar is displayed on screen
    expect(find.byType(TableCalendar), findsOneWidget);

    // Check if AppBar displays 'Activity'
    expect(find.text('Activity'), findsOneWidget);
  });
}
