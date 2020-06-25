import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentsocial/models/entities/login.dart';
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/models/entities/schedule.dart';
import 'package:studentsocial/models/entities/semester.dart';
import 'package:studentsocial/rest_api/rest_client.dart';

class LoginModel {
  LoginModel();

  String semester, token, mark, msv;
  Profile profile;
  ScheduleResult lichHoc;
  ScheduleResult lichThi;
  final RestClient _client = RestClient.create();
  final TextEditingController controllerEmail =
      TextEditingController();

  final TextEditingController controllerPassword =
      TextEditingController();

  bool get dataIsInvalid =>
      controllerEmail.text.trim().isEmpty ||
      controllerPassword.text.trim().isEmpty;

  String get getMSV => controllerEmail.text.trim().toUpperCase();

  String get getPassword => controllerPassword.text.trim();

  Future<LoginResult> login(String msv, String password) async {
    final LoginResult result = await _client.login(msv, password);
    if (result.isSuccess()) {
      this.msv = (result as LoginSuccess).message.Profile.MaSinhVien;
    }
    return result;
  }

  Future<SemesterResult> getSemester(String token) async {
    return await _client.getSemester(token);
  }

  Future<void> getLichHoc(String semester) async {
    lichHoc = await _client.getLichHoc(token, semester);
  }

  Future<void> getLichThi(String semester) async {
    lichThi = await _client.getLichThi(token, semester);
  }

  Future<void> saveMarkToDB() async {
    //TODO: save mark to db
//    var res = await PlatformChannel().saveMarkToDB(
//        mark, json.encode(subjectsName), json.encode(subjectsSoTinChi), msv);
//    print('saveMarkToDB: $res');
  }
}
