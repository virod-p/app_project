import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([SharedPreferences])
void main() {
  // Mocking SharedPreferences
  setUp(() async {
    SharedPreferences.setMockInitialValues(
        {}); // ตั้งค่า mock สำหรับ SharedPreferences

    await Supabase.initialize(
      url: '',
      anonKey: '',
    );
  });

  test('ทดสอบการดึงข้อมูลจาก Supabase', () async {
    await Supabase.instance.client
        .from('floor1')
        .select()
        .eq('id', 9)
        .then((response) {
      expect(response, isNotEmpty);
      expect(response[0]['name'], equals('Co-working space (AA)'));
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  });
}
