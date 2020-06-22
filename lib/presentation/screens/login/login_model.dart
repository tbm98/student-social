import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentsocial/models/entities/login.dart';
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/models/entities/schedule.dart';
import 'package:studentsocial/models/entities/semester.dart';
import 'package:studentsocial/rest_api/rest_client.dart';

class LoginModel {
  String semester, semesterKyTruoc, token, mark, msv;
  bool lichthilai = true;
  Profile profile;
  List<Schedule> lichHoc;
  List<Schedule> lichThi;
  List<Schedule> lichThiLai;
  Map<String, String> subjectsName = Map<String, String>();
  Map<String, String> subjectsSoTinChi = Map<String, String>();
  RestClient _client = RestClient.create();
  final controllerEmail = TextEditingController(text: 'DTC165D4801030252');
  final controllerPassword = TextEditingController(text: 'tbm01031998');

  LoginModel() {}

  bool get dataIsInvalid =>
      controllerEmail.text.trim().isEmpty ||
      controllerPassword.text.trim().isEmpty;

  get getMSV => controllerEmail.text.trim().toUpperCase();

  get getPassword => controllerPassword.text.trim();

  Future<LoginResult> login(msv, password) async {
    final result = await _client.login(msv, password);
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

  Future<void> getLichThiLai(String semester) async {
    lichThiLai = await _client.getLichThi(token, semester);
  }

  Future<void> getDiem() async {
//    mark = await _netWorking.getMark(token);
  }

  void addSubjectsName(maMon, tenMon) {
    subjectsName[maMon] = tenMon;
  }

  void addSubjectsSoTinChi(maMon, String soTinChi) {
    subjectsSoTinChi[maMon] = soTinChi;
  }

  Future saveMarkToDB() async {
//    var res = await PlatformChannel().saveMarkToDB(
//        mark, json.encode(subjectsName), json.encode(subjectsSoTinChi), msv);
//    print('saveMarkToDB: $res');
  }
}
