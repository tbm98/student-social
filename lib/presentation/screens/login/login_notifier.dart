import 'dart:async';
import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:studentsocial/models/entities/semester.dart';
import '../../../helpers/logging.dart';
import '../../../models/entities/login.dart';
import '../../../models/entities/profile.dart';
import '../../../models/local/database/database.dart';
import '../../../models/local/repository/profile_repository.dart';
import '../../../models/local/repository/schedule_repository.dart';
import '../../../models/local/shared_prefs.dart';
import 'login_model.dart';
import '../../../models/entities/schedule.dart';

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
    final SemesterResult semesterResult = await _loginModel.getSemester(token);
    logs('semesterResult is ${semesterResult.toJson()}');
    _pop();
    _inputAction()
        .add({'type': LoginAction.alert_chon_kyhoc, 'data': semesterResult});
  }

  void semesterClicked(String data) {
    logs('data is $data');
    _pop();
    _loginModel.semester = data;
    _loadData(_loginModel.semester);
  }

  Future<void> _loadData(String semester) async {
    _loading('Đang lấy lịch học');
    await _loginModel.getLichHoc(semester);
    _pop();
    _loading('Đang lấy lịch thi');
    await _loginModel.getLichThi(semester);
    _pop();
    _saveInfo();
  }

  Future<void> _saveInfo() async {
    //TODO: add later
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
    if (_loginModel.lichHoc.isSuccess()) {
      (_loginModel.lichHoc as ScheduleSuccess).message.addMSV(_loginModel.msv);
      await _scheduleRepository.insertListSchedules(
          (_loginModel.lichHoc as ScheduleSuccess).message.Entries);
    }
    if (_loginModel.lichThi.isSuccess()) {
      (_loginModel.lichThi as ScheduleSuccess).message.addMSV(_loginModel.msv);
      await _scheduleRepository.insertListSchedules(
          (_loginModel.lichThi as ScheduleSuccess).message.Entries);
    }
    _pop();
    _inputAction().add({'type': LoginAction.save_success});
    await Future.delayed(Duration(milliseconds: 800));
    _pop();
  }
}
