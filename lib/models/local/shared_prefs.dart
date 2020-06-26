import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefs = Provider((read) {
  return SharedPrefs();
});

class SharedPrefs {
  static const String currentMSV = 'current_msv';

  Future<bool> setCurrentMSV(String msv) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(currentMSV, msv);
  }

  Future<String> getCurrentMSV() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentMSV);
  }
}
