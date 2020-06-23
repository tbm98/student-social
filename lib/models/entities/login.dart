import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class ProfileInfor {
  ProfileInfor(
      {this.Id,
      this.MaSinhVien,
      this.HoTen,
      this.Lop,
      this.Nganh,
      this.NienKhoa,
      this.HeDaoTao,
      this.Truong});
  factory ProfileInfor.fromJson(Map<String, dynamic> json) =>
      _$ProfileInforFromJson(json);
  String Id;
  String MaSinhVien;
  String HoTen;
  String Lop;
  String Nganh;
  String NienKhoa;

  String HeDaoTao;

  String Truong;

  Map<String, dynamic> toJson() => _$ProfileInforToJson(this);
}

@JsonSerializable()
class MessageResult {
  MessageResult({this.Token, this.Profile});
  factory MessageResult.fromJson(Map<String, dynamic> json) =>
      _$MessageResultFromJson(json);

  String Token;

  ProfileInfor Profile;

  Map<String, dynamic> toJson() => _$MessageResultToJson(this);
}

@JsonSerializable()
class LoginSuccess implements LoginResult {
  LoginSuccess({this.status, this.message});
  factory LoginSuccess.fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessFromJson(json);

  String status;

  MessageResult message;

  @override
  bool isSuccess() {
    return status == 'success';
  }

  Map<String, dynamic> toJson() => _$LoginSuccessToJson(this);
}

@JsonSerializable()
class LoginFail implements LoginResult {
  LoginFail({this.status, this.message});
  factory LoginFail.fromJson(Map<String, dynamic> json) =>
      _$LoginFailFromJson(json);

  String status;

  String message;

  @override
  bool isSuccess() {
    return status == 'success';
  }

  Map<String, dynamic> toJson() => _$LoginFailToJson(this);
}

abstract class LoginResult {
  factory LoginResult.fromJson(Map<String, dynamic> json) {
    if (json['status'] == 'success') {
      return LoginSuccess.fromJson(json);
    } else {
      return LoginFail.fromJson(json);
    }
  }

  bool isSuccess();
}
