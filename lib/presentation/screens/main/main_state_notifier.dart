import 'dart:async';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/logging.dart';
import '../../../helpers/notification.dart';
import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';
import '../../../models/local/database/database.dart';
import '../../../models/local/repository/profile_repository.dart';
import '../../../models/local/repository/schedule_repository.dart';
import '../../../models/local/shared_prefs.dart';
import 'package:state_notifier/state_notifier.dart';

import 'main_state.dart';

enum MainAction {
  alert_with_message,
  alert_update_schedule,
  pop,
  forward,
  reverse
}

final mainStateNotifier = StateNotifierProvider<MainStateNotifier>((ref) {
  final database = ref.read(myDatabase).value;
  final shared = ref.read(sharedPrefs).value;
  return MainStateNotifier(
      ProfileRepository(database), ScheduleRepository(database), shared);
});

class MainStateNotifier extends StateNotifier<MainState> {
  MainStateNotifier(ProfileRepository profileRepository,
      ScheduleRepository scheduleRepository, SharedPrefs sharedPrefs)
      : super(const MainState()) {
    _profileRepository = profileRepository;
    _scheduleRepository = scheduleRepository;
    _sharedPrefs = sharedPrefs;
    _notification = Notification();
    _initLoad();
  }

  final StreamController _streamController = StreamController();
  Notification _notification;
  ProfileRepository _profileRepository;
  ScheduleRepository _scheduleRepository;

  SharedPrefs _sharedPrefs;

  get width => state.width;

  get tableHeight => state.tableHeight;

  get itemWidth => state.itemWidth;

  get itemHeight => state.itemHeight;

  get entriesOfDay => state.entriesOfDay;

  String get msv => state.msv;

  get clickDate => state.getClickDate;

  get getClass => state.getClass;

  bool get isGuest => state.isGuest;

  String get getAvatarName => state.getAvatarName;

  String get getName => state.getName;

  get allProfile => state.allProfile;

  Future<void> _initLoad() async {
    await insertProfileGuest();
    await loadCurrentMSV();
    await loadAllProfile();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Stream get getStreamAction => _streamController.stream;

  Sink get inputAction => _streamController.sink;

  Future<int> insertProfileGuest() async {
    return await _profileRepository.insertOnlyUser(Profile.guest());
  }

  Future<void> loadCurrentMSV() async {
    final String value = await _sharedPrefs.getCurrentMSV();

    if (value == null || value.isEmpty) {
      return;
    }
    if (value.isNotEmpty) {
      state = state.copyWith(msv: value);
    }
    loadProfile();
    loadSchedules();
    loadAllProfile();
  }

  Future<void> loadProfile() async {
    final Profile profile = await _profileRepository.getUserByMaSV(state.msv);
    state = state.copyWith(profile: profile);
  }

  Future<void> loadAllProfile() async {
    final List<Profile> profiles = await _profileRepository.getAllUsers();
    state = state.copyWith(allProfile: profiles);
  }

  Future<void> loadSchedules() async {
    final List<Schedule> schedule =
        await _scheduleRepository.getListSchedules(state.msv);
    state = state.copyWith(schedules: schedule);
    logs('schedule is ${schedule.length}');
    logs('msv is ${state.msv}');
    _initEntries(schedule);
  }

  void _initEntries(List<Schedule> schedules) {
    if (schedules.isEmpty) {
      return;
    } //neu gia tri ban dau rong thi se khong can initentries nua , return luon

    //clear entries map truoc khi init lan thu 2 tro di
    if (state.entriesOfDayNotEmpty) {
      state.clearEntriesOfDay();
    }
    _initEntriesBySchedule(schedules);
  }

  void _initEntriesBySchedule(List<Schedule> schedules) {
    final int len = schedules.length;
    Schedule schedule;
    Map<String, List<Schedule>> entriesOfDay = Map<String, List<Schedule>>()
      ..addAll(state.entriesOfDay);

    for (int i = 0; i < len; i++) {
      schedule = schedules[i];

      if (entriesOfDay[schedule.getNgay] == null) {
        entriesOfDay[schedule.getNgay] = <Schedule>[];
        // neu ngay cua entri nay chua co lich thi phai khoi tao trong map 1 list de luu lai duoc,
        //neu co roi thi thoi dung tiep
      }
      entriesOfDay[schedule.getNgay].add(schedule);
    }

    state = state.copyWith(entriesOfDay: entriesOfDay);

    //sau khi đã lấy được toàn bộ lịch rồi thì sẽ tiến hành đặt thông báo lịch hàng ngày.
    _notification.initSchedulesNotification(state.entriesOfDay, state.msv);
  }

  void updateSchedule() {
    _checkInternetConnectivity();
  }

  Future<void> _checkInternetConnectivity() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      inputAction.add({
        'type': MainAction.alert_with_message,
        'data': 'Không có kết nối mạng :('
      });
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      inputAction.add({'type': MainAction.alert_update_schedule});
    }
  }

  void initSize(Size size) {
    state = state.initSize(size);
  }

  Future<void> launchURL() async {
    const String url = 'https://m.me/hoangthang1412';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String getStringForKey(int i) {
    if (i < 10) {
      return '0$i';
    }
    return i.toString();
  }

  void clickedOnCurrentDay() {
    logs(
        'clickedOnDay ${getStringForKey(state.currentDate.day)},${getStringForKey(state.currentDate.month)},${state.currentDate.year} from calendar_widget');
    state = state.copyWith(clickDate: state.currentDate);
    if (!state.hideButtonCurrent) {
      //nếu đang hiện thì mới ẩn
      inputAction.add({'type': MainAction.reverse});
      state = state.copyWith(hideButtonCurrent: true);
    }
  }

  void clickedOnDay(int day, int month, int year) {
    logs(
        'clickedOnDay ${getStringForKey(day)},${getStringForKey(month)},$year from calendar_widget');
    state = state.copyWith(clickDate: DateTime(year, month, day));
    if (_isCurrentDay(day, month, year)) {
      if (!state.hideButtonCurrent) {
        //nếu đang hiện thì mới ẩn
        inputAction.add({'type': MainAction.reverse});
        state = state.copyWith(hideButtonCurrent: true);
      }
    } else {
      if (state.hideButtonCurrent) {
        inputAction.add({'type': MainAction.forward});
        state = state.copyWith(hideButtonCurrent: false);
      }
    }
  }

  bool _isCurrentDay(int d, int m, int y) {
    return d == state.getCurrentDate.day &&
        m == state.getCurrentDate.month &&
        y == state.getCurrentDate.year;
  }

  void setClickDay(int clickDay) {
    state = state.copyWith(
        clickDate: DateTime(
            state.getClickDate.year, state.getClickDate.month, clickDay));
  }

  void setClickMonth(int month) {
    state = state.copyWith(
        clickDate:
            DateTime(state.getClickDate.year, month, state.getClickDate.day));
  }

  Future<void> logOut() async {
    //kiểm tra xem còn profile nào không, nếu còn thì mặc định nó lấy luôn thằng profile đầu tiên để sử dụng tiếp
    // nếu không còn thằng profile nào thì set currentmsv = '',
    //xoá hết lịch,điểm,profile của thằng msv hiện tại

    try {
      List<Profile> profiles = await _profileRepository.getAllUsers();

      //lấy ra toàn bộ user có trong máy
      profiles.removeWhere((profile) =>
          profile.MaSinhVien ==
          state.msv); // xoá đi user hiện tại muốn đăng xuất
      //kiểm tra nếu list vẫn còn user thì gán vào shared msv của thằng đầu tiên luôn
      //nếu không còn thằng nào thì gán vào shared '' (empty)
      if (profiles.isNotEmpty) {
        await _sharedPrefs.setCurrentMSV(profiles[0].MaSinhVien);
      } else {
        //không còn thằng nào :((
        await _sharedPrefs.setCurrentMSV('');
      }
      //Xoá profile
      await _profileRepository.deleteUserByMSV(state.msv);
      //Xoá điểm
      //TODO: Xoa diem
//      await PlatformChannel.database.invokeMethod(
//          PlatformChannel.removeMarkByMSV,
//          <String, String>{'msv': _mainModel.msv});
      //Xoá lịch
      await _scheduleRepository.deleteScheduleByMSV(state.msv);
      //reset data
      state = state.resetData();
      loadCurrentMSV();
      inputAction.add({
        'type': MainAction.alert_with_message,
        'data': 'Đăng xuất thành công'
      });
    } catch (e) {
      logs('error is:$e');
      state = state.resetData();
      loadCurrentMSV();
      inputAction.add({
        'type': MainAction.alert_with_message,
        'data': 'Đăng xuất bị lỗi: $e'
      });
    }
  }

  Future<void> switchToProfile(Profile profile) async {
    // đặt lại currentmsv trong shared
    await _sharedPrefs.setCurrentMSV(profile.MaSinhVien);
//    reset data
    state = state.resetData();
    loadCurrentMSV();
  }

  getRandomColor() {
//    return _mainModel.colors[Random().nextInt(_mainModel.colors.length)];
  }

  void calendarPageChanged(int index) {
//    if (index != 12) {
    //nếu nhảy sang page khác page mặc định thì hiện lên
//      if (_mainModel.hideButtonCurrent) {
//        inputAction.add({'type': MainAction.forward});
//        _mainModel.hideButtonCurrent = false;
//      }
//    } else if (_isCurrentDay(
//        _mainModel.clickDay, _mainModel.clickMonth, _mainModel.clickYear)) {
//      nếu là page mặc định và ngày đang chọn cũng là currentday thì ẩn nó đi
//      if (!_mainModel.hideButtonCurrent) {
//        inputAction.add({'type': MainAction.reverse});
//        _mainModel.hideButtonCurrent = true;
//      }
//    }
  }
}
