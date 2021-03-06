import 'url.dart';
import 'package:http/http.dart' as http;

class NetWorking {
  Future<String> getToken(String msv, String password) async {
    var res = await http
        .post(URL.LOGIN, body: {"username": msv, "password": password});
    if (res.statusCode == 200) {
      var data = res.body.replaceAll("\"", "");
      return data;
    } else {
      return '';
    }
  }

  Future<String> getSemester(String token) async {
    var res =
        await http.post(URL.GET_SEMESTER, headers: {"access-token": token});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return '';
    }
  }

  Future<String> getProfile(String token) async {
    var res =
        await http.post(URL.GET_PROFILE, headers: {"access-token": token});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return '';
    }
  }

  Future<String> getMark(String token) async {
    var res = await http.post(URL.GET_MARK, headers: {"access-token": token});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return '';
    }
  }

  Future<String> getLichHoc(String token, String semester) async {
    var res = await http.post(URL.GET_LICHHOC,
        headers: {"access-token": token}, body: {"semester": semester});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return '';
    }
  }

  //hàm này dùng cho cả getlichthilai vì đều là lịch thi (chỉ khác semester)
  Future<String> getLichThi(String token, String semester) async {
    var res = await http.post(URL.GET_LICHTHI,
        headers: {"access-token": token}, body: {"semester": semester});
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return '';
    }
  }
}
