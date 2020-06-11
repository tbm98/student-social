import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class ProfileInfor {
  String Id;
  String MaSinhVien;
  String Ten;
  String Lop;
  String Nganh;
  String NamHoc;
  String HeDaoTao;

  ProfileInfor(
      {this.Id,
      this.MaSinhVien,
      this.Ten,
      this.Lop,
      this.Nganh,
      this.NamHoc,
      this.HeDaoTao});

  factory ProfileInfor.fromJson(Map<String, dynamic> json) =>
      _$ProfileInforFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileInforToJson(this);
}

@JsonSerializable()
class MessageResult {
  String Token;
  ProfileInfor Profile;

  MessageResult({this.Token, this.Profile});

  factory MessageResult.fromJson(Map<String, dynamic> json) =>
      _$MessageResultFromJson(json);

  Map<String, dynamic> toJson() => _$MessageResultToJson(this);
}

@JsonSerializable()
class LoginSuccess implements LoginResult {
  String status;
  MessageResult message;

  @override
  bool isSuccess() {
    return status == 'success';
  }

  LoginSuccess({this.status, this.message});

  factory LoginSuccess.fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessFromJson(json);

  Map<String, dynamic> toJson() => _$LoginSuccessToJson(this);
}

@JsonSerializable()
class LoginFail implements LoginResult {
  String status;
  String message;

  @override
  bool isSuccess() {
    return status == 'success';
  }

  LoginFail({this.status, this.message});

  factory LoginFail.fromJson(Map<String, dynamic> json) =>
      _$LoginFailFromJson(json);

  Map<String, dynamic> toJson() => _$LoginFailToJson(this);
}

abstract class LoginResult {
  bool isSuccess();

  factory LoginResult(Map<String, dynamic> json) {
    if (json['status'] == 'success') {
      return LoginSuccess.fromJson(json);
    } else {
      return LoginFail.fromJson(json);
    }
  }
}
