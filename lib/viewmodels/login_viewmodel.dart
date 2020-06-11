import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:studentsocial/models/entities/login.dart';
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/models/login_model.dart';
import 'package:studentsocial/support/platform_channel.dart';

enum LoginAction {
  alert_with_message,
  loading,
  alert_chon_kyhoc,
  pop,
  save_success
}

class LoginViewModel with ChangeNotifier {
  LoginModel _loginModel;
  StreamController _streamController;

  LoginViewModel() {
    _loginModel = LoginModel();
    _streamController = StreamController();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  get getControllerMSV => _loginModel.controllerEmail;

  get getControllerPassword => _loginModel.controllerPassword;

  Sink _inputAction() {
    return _streamController.sink;
  }

  Stream getActionStream() {
    return _streamController.stream;
  }

  _pop() {
    _inputAction().add({'type': LoginAction.pop});
  }

  _loading(String msg) {
    _inputAction().add({'type': LoginAction.loading, 'data': msg});
  }

  void submit() async{
    final bool isOnline = await _checkInternetConnectivity();
    if(!isOnline){
      return;
    }
    _actionLogin();
  }

  Future<bool> _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Không có kết nối mạng :('
      });
      return false;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  _actionLogin() {
    if (_loginModel.dataIsInvalid) {
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Bạn không được để trống tài khoản mật khẩu'
      });
    } else {
      _loading('Đang đăng nhập...');
      var tk = _loginModel.getMSV;
      var mk = _loginModel.getPassword;
      _login(tk, mk);
    }
  }

  void _login(msv, password) async {
    final result = await _loginModel.login(msv, password);
    _loginModel.msv = msv;
    if (result.isSuccess()) {
      _loginModel.token = (result as LoginSuccess).message.Token;
      _pop();
      _loading('Đang tải kỳ học');
      _getSemester(_loginModel.token);
    } else {
      _pop();
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Tài khoản hoặc mật khẩu đăng nhập sai, vui lòng thử lại'
      });
    }
  }

  void _getSemester(String token) async {
//    print('token is $token');
    final semesterResult = await _loginModel.getSemester(token);
//    print('data is $data');
    _pop();
    _inputAction()
        .add({'type': LoginAction.alert_chon_kyhoc, 'data': semesterResult});
  }

  void semesterClicked(data, kyTruoc) {
    _pop();
    _loginModel.semester = data;
    if (kyTruoc != null) {
      _loginModel.semesterKyTruoc = kyTruoc;
    }
    _loadData(_loginModel.semester, _loginModel.semesterKyTruoc);
  }

  void _loadData(String semester, String semesterKyTruoc) async {
    _loading('Đang lấy dữ liệu người dùng');
    await _loginModel.getProfile();
    _pop();
    _loading('Đang lấy thông tin điểm');
    await _loginModel.getDiem();
    _pop();
    _loading('Đang lấy lịch học');
    await _loginModel.getLichHoc(semester);
    _pop();
    _loading('Đang lấy lịch thi');
    await _loginModel.getLichThi(semester);
    _pop();
    if (semesterKyTruoc.isNotEmpty) {
      _loading('Đang lấy lịch thi lại');
      await _loginModel.getLichThiLai(semesterKyTruoc);
      _pop();
    }
    _saveInfo();
  }

  void addSubjects(value) {
    print('value addSubjects is $value');
    var jsonValue = json.decode(value);
    var listSubjects = jsonValue['message']['Subjects'];
    for (var item in listSubjects) {
      _loginModel.addSubjectsName(item['MaMon'], item['TenMon']);
      _loginModel.addSubjectsSoTinChi(
          item['MaMon'], item['SoTinChi'].toString());
    }
  }

  void _saveInfo() async {
    //tách và lấy ra tất cả tên và số tín chỉ của từng môn học
    addSubjects(_loginModel.lichHoc);
    addSubjects(_loginModel.lichThi);
    addSubjects(_loginModel.lichThiLai);
    //TODO: add later
//    addSubjects(_loginModel.mark);
    //validate profile
//    var jsonMark = json.decode(_loginModel.mark);
//    Profile profile = Profile.fromJson(json.decode(_loginModel.profile));
//    profile.setMoreDetail(
//        jsonMark['TongTC'],
//        jsonMark['STCTD'],
//        jsonMark['STCTLN'],
//        jsonMark['DTBC'],
//        jsonMark['DTBCQD'],
//        jsonMark['SoMonKhongDat'],
//        jsonMark['SoTCKhongDat'],
//        _loginModel.token);
    //validate diem
//    _loginModel.validateMark();
    //validate lich hoc
    _loginModel.validateLichHoc();
    //validate lich thi
    _loginModel.validateLichThi();
    //validate lich thi lai
    _loginModel.validateLichThiLai();

    _loading('Đang lưu thông tin người dùng');
    var resProfile =
        await PlatformChannel().saveProfileToDB(json.encode(profile));
    _pop();
    print('saveProfileToDB: $resProfile');
    if (resProfile.contains('ERROR')) {
      //error
      _inputAction()
          .add({'type': LoginAction.alert_with_message, 'data': resProfile});
      return;
    }
    var resCurrentMSV = await PlatformChannel().saveCurrentMSV(_loginModel.msv);
    print('saveCurrentMSV:$resCurrentMSV');
    _loading('Đang lưu điểm và lịch cá nhân');
    await _loginModel.saveMarkToDB();
    await _loginModel.saveScheduleToDB();
    _pop();
    _inputAction().add({'type': LoginAction.save_success});
  }
}
