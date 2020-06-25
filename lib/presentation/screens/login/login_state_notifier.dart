import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:studentsocial/models/entities/semester.dart';
import 'package:studentsocial/rest_api/rest_client.dart';

import '../../../helpers/logging.dart';
import '../../../models/entities/login.dart';
import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';
import '../../../models/local/database/database.dart';
import '../../../models/local/repository/profile_repository.dart';
import '../../../models/local/repository/schedule_repository.dart';
import '../../../models/local/shared_prefs.dart';
import 'login_state.dart';

enum LoginAction {
  alert_with_message,
  loading,
  alert_chon_kyhoc,
  pop,
  save_success
}

final loginStateNotifier = StateNotifierProvider((ref) {
  final database = ref.read(myDatabase).value;
  final shared = ref.read(sharedPrefs).value;
  final client = ref.read(restClient).value;

  return LoginStateNotifier(ProfileRepository(database),
      ScheduleRepository(database), shared, client);
});

class LoginStateNotifier extends StateNotifier<LoginState> {
  LoginStateNotifier(
      ProfileRepository profileRepository,
      ScheduleRepository scheduleRepository,
      SharedPrefs sharedPrefs,
      RestClient client)
      : super(const LoginState()) {
    _sharedPrefs = sharedPrefs;
    _profileRepository = profileRepository;
    _scheduleRepository = scheduleRepository;
    _client = client;
    _streamController = StreamController();
  }

  StreamController _streamController;
  ProfileRepository _profileRepository;
  ScheduleRepository _scheduleRepository;
  RestClient _client;
  SharedPrefs _sharedPrefs;

  bool dataIsInvalid(String email, String password) =>
      email.trim().isEmpty || password.trim().isEmpty;

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<LoginResult> login(String msv, String password) async {
    final LoginResult result = await _client.login(msv, password);
    if (result.isSuccess()) {
      state = state.copyWith(
          msv: (result as LoginSuccess).message.Profile.MaSinhVien);
    }
    return result;
  }

  Future<SemesterResult> getSemester(String token) async {
    return await _client.getSemester(token);
  }

  Future<void> getLichHoc(String semester) async {
    final lichHoc = await _client.getLichHoc(state.token, semester);
    state = state.copyWith(lichHoc: lichHoc);
  }

  Future<void> getLichThi(String semester) async {
    final lichThi = await _client.getLichThi(state.token, semester);
    state = state.copyWith(lichThi: lichThi);
  }

  Future<void> saveMarkToDB() async {
    //TODO: save mark to db
//    var res = await PlatformChannel().saveMarkToDB(
//        mark, json.encode(subjectsName), json.encode(subjectsSoTinChi), msv);
//    print('saveMarkToDB: $res');
  }

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

  Future<void> submit(String email, String password) async {
    final bool isOnline = await _checkInternetConnectivity();
    if (!isOnline) {
      return;
    }
    _actionLogin(email, password);
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

  void _actionLogin(String email, String password) {
    if (dataIsInvalid(email, password)) {
      _inputAction().add({
        'type': LoginAction.alert_with_message,
        'data': 'Bạn không được để trống tài khoản mật khẩu'
      });
    } else {
      _loading('Đang đăng nhập...');
      _login(email, password);
    }
  }

  Future<void> _login(String msv, String password) async {
    final LoginResult result = await login(msv, password);
    state = state.copyWith(msv: msv);
    if (result.isSuccess()) {
      final profile =
          Profile.fromJson((result as LoginSuccess).message.Profile.toJson());
      final token = (result as LoginSuccess).message.Token;
      state = state.copyWith(profile: profile, token: token);
      _pop();
      _loading('Đang tải kỳ học');
      _getSemester(state.token);
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
    final SemesterResult semesterResult = await getSemester(token);
    logs('semesterResult is ${semesterResult.toJson()}');
    _pop();
    _inputAction()
        .add({'type': LoginAction.alert_chon_kyhoc, 'data': semesterResult});
  }

  void semesterClicked(String data) {
    logs('data is $data');
    _pop();
    state = state.copyWith(semester: data);
    _loadData(data);
  }

  Future<void> _loadData(String semester) async {
    _loading('Đang lấy lịch học');
    await getLichHoc(semester);
    _pop();
    _loading('Đang lấy lịch thi');
    await getLichThi(semester);
    _pop();
    _saveInfo();
  }

  Future<void> _saveInfo() async {
    //TODO: add later
    _loading('Đang lưu thông tin người dùng');
    final int resProfile =
        await _profileRepository.insertOnlyUser(state.profile);
    _pop();
    logs('saveProfileToDB: $resProfile');
    final bool resCurrentMSV = await _sharedPrefs.setCurrentMSV(state.msv);
    logs('saveCurrentMSV:$resCurrentMSV');
    _loading('Đang lưu điểm và lịch cá nhân');
    await saveMarkToDB();
    if (state.lichHoc.isSuccess()) {
      (state.lichHoc as ScheduleSuccess).message.addMSV(state.msv);
      await _scheduleRepository.insertListSchedules(
          (state.lichHoc as ScheduleSuccess).message.Entries);
    }
    if (state.lichThi.isSuccess()) {
      (state.lichThi as ScheduleSuccess).message.addMSV(state.msv);
      await _scheduleRepository.insertListSchedules(
          (state.lichThi as ScheduleSuccess).message.Entries);
    }
    _pop();
    _inputAction().add({'type': LoginAction.save_success});
    await Future.delayed(Duration(milliseconds: 800));
    _pop();
  }
}
