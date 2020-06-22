import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:studentsocial/models/entities/db_parseable.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule extends DBParseable {
  static const table = 'Schedule';
  static const createQuery = '''CREATE TABLE IF NOT EXISTS Schedule (
  ID INTEGER PRIMARY KEY AUTOINCREMENT,
  MaSinhVien TEXT,
  MaMon TEXT,
  TenMon TEXT,
  ThoiGian TEXT,
  Ngay TEXT,
  DiaDiem TEXT,
  HinhThuc TEXT,
  GiaoVien TEXT,
  LoaiLich TEXT,
  SoBaoDanh TEXT,
  SoTinChi TEXT
  )''';
  static const dropQuery = 'DROP TABLE IF EXISTS Schedule;';
  final int ID;

  final String MaSinhVien;

  String MaMon;

  final String TenMon;

  String ThoiGian;

  final String Ngay;

  final String DiaDiem;

  final String HinhThuc;

  final String GiaoVien;

  final String LoaiLich;

  final String SoBaoDanh;

  final String SoTinChi;

  Schedule(
      {this.ID,
      this.MaSinhVien,
      this.MaMon,
      this.TenMon,
      this.ThoiGian,
      this.Ngay,
      this.DiaDiem,
      this.HinhThuc,
      this.GiaoVien,
      this.LoaiLich,
      this.SoBaoDanh,
      this.SoTinChi});

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
  Map<String, dynamic> toMap() => _$ScheduleToJson(this);

  factory Schedule.forNote(
      String msv, String tieuDe, String noiDung, String ngay) {
    return Schedule(
        MaSinhVien: msv,
        MaMon: tieuDe,
        ThoiGian: noiDung,
        Ngay: ngay,
        LoaiLich: 'Note');
  }

  //sinh chuỗi để tạo note từ object hiện có
  String toStringForNote() {
    return jsonEncode(this);
//    return "{\"ID\":\"$ID\",\"MaSinhVien\":\"$MaSinhVien\",\"MaMon\":\"$MaMon\",\"TenMon\":\"$TenMon\",\"ThoiGian\":\"$ThoiGian\",\"Ngay\":\"$Ngay\",\"DiaDiem\":\"$DiaDiem\",\"HinhThuc\":\"$HinhThuc\",\"GiaoVien\":\"$GiaoVien\",\"LoaiLich\":\"$LoaiLich\",\"SoBaoDanh\":\"$SoBaoDanh\",\"SoTinChi\":\"$SoTinChi\"}";
  }

  bool equals(Schedule schedule) {
    return MaSinhVien == schedule.MaSinhVien &&
        MaMon == schedule.MaMon &&
        TenMon == schedule.TenMon &&
        ThoiGian == schedule.ThoiGian &&
        Ngay == schedule.Ngay &&
        DiaDiem == schedule.DiaDiem &&
        HinhThuc == schedule.HinhThuc &&
        GiaoVien == schedule.GiaoVien &&
        LoaiLich == schedule.LoaiLich &&
        SoBaoDanh == schedule.SoBaoDanh &&
        SoTinChi == schedule.SoTinChi;
  }

  @override
  String get tableName => 'Schedule';
}
