import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const currentMSV = 'current_msv';
  Future<bool> setCurrentMSV(String msv) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(currentMSV, msv);
  }

  Future<String> getCurrentMSV() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(currentMSV);
  }
}
