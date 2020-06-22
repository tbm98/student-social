import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import '../../../helpers/logging.dart';
import '../../../models/entities/login.dart';
import '../../../models/entities/profile.dart';
import '../../../models/local/database/database.dart';
import '../../../models/local/repository/profile_repository.dart';
import '../../../models/local/repository/schedule_repository.dart';
import '../../../models/local/shared_prefs.dart';
import 'login_model.dart';

enum LoginAction {
  alert_with_message,
  loading,
  alert_chon_kyhoc,
  pop,
  save_success
}

class LoginNotifier with ChangeNotifier {
  LoginNotifier(MyDatabase database) {
    _sharedPrefs = SharedPrefs();
    _profileRepository = ProfileRepository(database);
    _scheduleRepository = ScheduleRepository(database);
    _loginModel = LoginModel();
    _streamController = StreamController();
  }
  LoginModel _loginModel;
  StreamController _streamController;
  ProfileRepository _profileRepository;
  ScheduleRepository _scheduleRepository;

  SharedPrefs _sharedPrefs;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  TextEditingController get getControllerMSV => _loginModel.controllerEmail;

  TextEditingController get getControllerPassword =>
      _loginModel.controllerPassword;

  Sink _inputAction() {
    return _streamController.sink;
  }

  Stream getActionStream() {
    return _streamController.stream;
  }

  void _pop() {
    _inputAction().add({'type': LoginAction.pop});
  }

  void _loading(String msg) {
    _inputAction().add({'type': LoginAction.loading, 'data': msg});
  }

  Future<void> submit() async {
    final bool isOnline = await _checkInternetConnectivity();
    if (!isOnline) {
      return;
    }
    _actionLogin();
  }

  Future<bool> _checkInternetConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
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

  void _actionLogin() {
    if (_loginModel.dataIsInvalid) {
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Bạn không được để trống tài khoản mật khẩu'
      });
    } else {
      _loading('Đang đăng nhập...');
      final String tk = _loginModel.getMSV;
      final String mk = _loginModel.getPassword;
      _login(tk, mk);
    }
  }

  Future<void> _login(String msv, String password) async {
    final LoginResult result = await _loginModel.login(msv, password);
    _loginModel.msv = msv;
    if (result.isSuccess()) {
      _loginModel.profile =
          Profile.fromJson((result as LoginSuccess).message.Profile.toJson());
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

  Future<void> _getSemester(String token) async {
    logs('token is $token');
    final semesterResult = await _loginModel.getSemester(token);
    logs('semesterResult is ${semesterResult.toJson()}');
    _pop();
    _inputAction()
        .add({'type': LoginAction.alert_chon_kyhoc, 'data': semesterResult});
  }

  void semesterClicked(String data, String kyTruoc) {
    logs('data is $data');
    logs('kyTruoc is $kyTruoc');
    _pop();
    _loginModel.semester = data;
    if (kyTruoc != null) {
      _loginModel.semesterKyTruoc = kyTruoc;
    }
    _loadData(_loginModel.semester, _loginModel.semesterKyTruoc);
  }

  Future<void> _loadData(String semester, String semesterKyTruoc) async {
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
    logs('value addSubjects is $value');
    final jsonValue = json.decode(value);
    final listSubjects = jsonValue['message']['Subjects'];
    for (final item in listSubjects) {
      _loginModel.addSubjectsName(item['MaMon'], item['TenMon']);
      _loginModel.addSubjectsSoTinChi(
          item['MaMon'], item['SoTinChi'].toString());
    }
  }

  Future<void> _saveInfo() async {
    //tách và lấy ra tất cả tên và số tín chỉ của từng môn học
    addSubjects(_loginModel.lichHoc);
    addSubjects(_loginModel.lichThi);
    addSubjects(_loginModel.lichThiLai);
    //TODO: add later
//    addSubjects(_loginModel.mark);
    //validate profile
//    var jsonMark = json.decode(_loginModel.mark);
//    profile.setMoreDetail(
//        jsonMark['TongTC'],
//        jsonMark['STCTD'],
//        jsonMark['STCTLN'],
//        jsonMark['DTBC'],
//        jsonMark['DTBCQD'],
//        jsonMark['SoMonKhongDat'],
//        jsonMark['SoTCKhongDat'],
//        _loginModel.token);

    _loading('Đang lưu thông tin người dùng');
    final int resProfile =
        await _profileRepository.insertOnlyUser(_loginModel.profile);
    _pop();
    logs('saveProfileToDB: $resProfile');
    final bool resCurrentMSV =
        await _sharedPrefs.setCurrentMSV(_loginModel.msv);
    logs('saveCurrentMSV:$resCurrentMSV');
    _loading('Đang lưu điểm và lịch cá nhân');
    await _loginModel.saveMarkToDB();
    await _scheduleRepository.insertListSchedules(_loginModel.lichHoc);
    await _scheduleRepository.insertListSchedules(_loginModel.lichThi);
    await _scheduleRepository.insertListSchedules(_loginModel.lichThiLai);
    _pop();
    _inputAction().add({'type': LoginAction.save_success});
  }
}
