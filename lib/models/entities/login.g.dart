// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileInfor _$ProfileInforFromJson(Map<String, dynamic> json) {
  return ProfileInfor(
    Id: json['Id'] as String,
    MaSinhVien: json['MaSinhVien'] as String,
    Ten: json['Ten'] as String,
    Lop: json['Lop'] as String,
    Nganh: json['Nganh'] as String,
    NamHoc: json['NamHoc'] as String,
    HeDaoTao: json['HeDaoTao'] as String,
  );
}

Map<String, dynamic> _$ProfileInforToJson(ProfileInfor instance) =>
    <String, dynamic>{
      'Id': instance.Id,
      'MaSinhVien': instance.MaSinhVien,
      'Ten': instance.Ten,
      'Lop': instance.Lop,
      'Nganh': instance.Nganh,
      'NamHoc': instance.NamHoc,
      'HeDaoTao': instance.HeDaoTao,
    };

MessageResult _$MessageResultFromJson(Map<String, dynamic> json) {
  return MessageResult(
    Token: json['Token'] as String,
    Profile: json['Profile'] == null
        ? null
        : ProfileInfor.fromJson(json['Profile'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MessageResultToJson(MessageResult instance) =>
    <String, dynamic>{
      'Token': instance.Token,
      'Profile': instance.Profile,
    };

LoginSuccess _$LoginSuccessFromJson(Map<String, dynamic> json) {
  return LoginSuccess(
    status: json['status'] as String,
    message: json['message'] == null
        ? null
        : MessageResult.fromJson(json['message'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$LoginSuccessToJson(LoginSuccess instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };

LoginFail _$LoginFailFromJson(Map<String, dynamic> json) {
  return LoginFail(
    status: json['status'] as String,
    message: json['message'] as String,
  );
}

Map<String, dynamic> _$LoginFailToJson(LoginFail instance) => <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
