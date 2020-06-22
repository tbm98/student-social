// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) {
  return Schedule(
    ID: json['ID'] as int,
    MaSinhVien: json['MaSinhVien'] as String,
    MaMon: json['MaMon'] as String,
    TenMon: json['TenMon'] as String,
    ThoiGian: json['ThoiGian'] as String,
    Ngay: json['Ngay'] as String,
    DiaDiem: json['DiaDiem'] as String,
    HinhThuc: json['HinhThuc'] as String,
    GiaoVien: json['GiaoVien'] as String,
    LoaiLich: json['LoaiLich'] as String,
    SoBaoDanh: json['SoBaoDanh'] as String,
    SoTinChi: json['SoTinChi'] as String,
  );
}

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'ID': instance.ID,
      'MaSinhVien': instance.MaSinhVien,
      'MaMon': instance.MaMon,
      'TenMon': instance.TenMon,
      'ThoiGian': instance.ThoiGian,
      'Ngay': instance.Ngay,
      'DiaDiem': instance.DiaDiem,
      'HinhThuc': instance.HinhThuc,
      'GiaoVien': instance.GiaoVien,
      'LoaiLich': instance.LoaiLich,
      'SoBaoDanh': instance.SoBaoDanh,
      'SoTinChi': instance.SoTinChi,
    };
