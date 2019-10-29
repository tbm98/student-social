import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentsocial/support/networking.dart';
import 'package:studentsocial/support/platform_channel.dart';

class LoginModel {
  String semester,
      semesterKyTruoc,
      token,
      lichHoc,
      lichThi,
      lichThiLai,
      mark,
      profile,
      msv;
  bool lichthilai = true;
  Map<String, String> subjectsName = Map<String, String>();
  Map<String, String> subjectsSoTinChi = Map<String, String>();
  MethodChannel saveProfile;
  MethodChannel saveDiem;
  MethodChannel saveLich;
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  NetWorking _netWorking;

  LoginModel() {
    _netWorking = NetWorking();
  }

  bool get dataIsInvalid =>
      controllerEmail.text.trim().isEmpty ||
      controllerPassword.text.trim().isEmpty;

  get getMSV => controllerEmail.text.trim().toUpperCase();

  get getPassword => controllerPassword.text.trim();

  Future<String> getToken(msv, password) async {
    this.msv = msv;
    return await _netWorking.getToken(msv, password);
  }

  Future<String> getSemester(String token) async {
    return await _netWorking.getSemester(token);
  }

  Future<void> getLichHoc(String semester) async {
    lichHoc = await _netWorking.getLichHoc(token, semester);
  }

  Future<void> getLichThi(String semester) async {
    lichThi = await _netWorking.getLichThi(token, semester);
  }

  Future<void> getLichThiLai(String semester) async {
    lichThiLai = await _netWorking.getLichThi(token, semester);
  }

  Future<void> getProfile() async {
    profile = await _netWorking.getProfile(token);
  }

  Future<void> getDiem() async {
    mark = await _netWorking.getMark(token);
  }

  void addSubjectsName(maMon, tenMon) {
    subjectsName[maMon] = tenMon;
  }

  void addSubjectsSoTinChi(maMon, String soTinChi) {
    subjectsSoTinChi[maMon] = soTinChi;
  }

  void validateMark() {
    mark = mark.substring(mark.indexOf('['));
    mark = mark.substring(0, mark.indexOf(']') + 1);
  }

  void validateLichHoc() {
    lichHoc = lichHoc.substring(lichHoc.indexOf('['));
    lichHoc = lichHoc.substring(0, lichHoc.indexOf(']') + 1);
  }

  void validateLichThi() {
    lichThi = lichThi.substring(lichThi.indexOf('['));
    lichThi = lichThi.substring(0, lichThi.indexOf(']') + 1);
  }

  void validateLichThiLai() {
    lichThiLai = lichThiLai.substring(lichThiLai.indexOf('['));
    lichThiLai = lichThiLai.substring(0, lichThiLai.indexOf(']') + 1);
  }

  Future saveMarkToDB() async {
    var res = await PlatformChannel().saveMarkToDB(
        mark, json.encode(subjectsName), json.encode(subjectsSoTinChi), msv);
    print('saveMarkToDB: $res');
  }

  Future saveScheduleToDB() async {
    var res = await PlatformChannel().saveScheduleToDB(
        lichHoc, lichThi, lichThiLai, msv, json.encode(subjectsName));
    print('saveScheduleToDB: $res');
  }
}
