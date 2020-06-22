import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:studentsocial/helpers/logging.dart';
import 'package:studentsocial/helpers/notification.dart';
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/models/entities/schedule.dart';
import 'package:studentsocial/models/local/database/database.dart';
import 'package:studentsocial/models/local/repository/profile_repository.dart';
import 'package:studentsocial/models/local/repository/schedule_repository.dart';
import 'package:studentsocial/models/local/shared_prefs.dart';
import 'package:studentsocial/presentation/screens/main/main_model.dart';
import 'package:url_launcher/url_launcher.dart';

enum MainAction {
  alert_with_message,
  alert_update_schedule,
  pop,
  forward,
  reverse
}

class MainNotifier with ChangeNotifier {
  MainModel _mainModel;
  StreamController _streamController = StreamController();
  Notification _notification;
  ProfileRepository _profileRepository;
  ScheduleRepository _scheduleRepository;
  SharedPrefs _sharedPrefs;

  MainNotifier(MyDatabase database) {
    _profileRepository = ProfileRepository(database);
    _scheduleRepository = ScheduleRepository(database);
    _mainModel = MainModel();
    _notification = Notification();
    _sharedPrefs = SharedPrefs();
    _initLoad();
  }

  void _initLoad() async {
    await insertProfileGuest();
    await loadCurrentMSV();
    await loadAllProfile();
  }

  get getAllProfile => _mainModel.allProfile;

  get getClickedDay => DateTime(
      _mainModel.clickYear, _mainModel.clickMonth, _mainModel.clickDay);

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Stream get getStreamAction => _streamController.stream;

  Sink get inputAction => _streamController.sink;

  String get getTitle => _mainModel.title;

  get getSchedules => _mainModel.schedules;

  get getWidth => _mainModel.width;

  get getItemWidth => _mainModel.itemWidth;

  get getItemHeight => _mainModel.itemHeight;

  get getDrawerHeaderHeight => _mainModel.drawerHeaderHeight;

  String get getName {
    if (_mainModel.msv == 'guest') {
      return 'Khách';
    }
    return _mainModel?.profile?.HoTen ?? 'Họ Tên';
  }

  String get getClass => _mainModel?.profile?.Lop ?? '';

  String get getToken => _mainModel?.profile?.Token ?? '';

  Map<String, List<Schedule>> get getEntriesOfDay => _mainModel.entriesOfDay;

  get getTableHeight => _mainModel.tableHeight;

  get getClickMonth => _mainModel.clickMonth;

  get getDateCurrentClick => _mainModel.getDateCurrentClick;

  get getKeyOfCurrentEntries => _mainModel.keyOfCurrentEntries;

  int get getCurrentDay => _mainModel.currentDay;

  int get getCurrentMonth => _mainModel.currentMonth;

  int get getCurrentYear => _mainModel.currentYear;

  int get getClickDay => _mainModel.clickDay;

  String get getMSV => _mainModel.msv;

  bool get isGuest =>
      getMSV == null ||
      getMSV == 'guest' ||
      getName == null ||
      getName == 'Họ Tên';

  String get getAvatarName {
    final name = getName;
    final splitName = name.split(' ');
    return splitName.last[0];
  }

  Future<int> insertProfileGuest() async {
    return await _profileRepository.insertOnlyUser(Profile.guest());
  }

  Future<void> loadCurrentMSV() async {
    final value = await _sharedPrefs.getCurrentMSV();

    if (value == null || value.isEmpty) {
      return;
    }
    if (value.isNotEmpty) {
      _mainModel.msv = value;
    }
    loadProfile();
    loadSchedules();
    loadAllProfile();
  }

  void loadProfile() async {
    final profile = await _profileRepository.getUserByMaSV(_mainModel.msv);
    _mainModel.profile = profile;
    notifyListeners();
  }

  void loadAllProfile() async {
    final profiles = await _profileRepository.getAllUsers();
    _mainModel.allProfile = profiles;
    notifyListeners();
  }

  void loadSchedules() async {
    final schedule = await _scheduleRepository.getListSchedules(_mainModel.msv);
    _mainModel.schedules = schedule;
    logs('schedule is $schedule');
    logs('msv is ${_mainModel.msv}');
    _initEntries(schedule);
  }

  void _initEntries(List<Schedule> schedules) {
    if (schedules.isEmpty) {
      return;
    } //neu gia tri ban dau rong thi se khong can initentries nua , return luon

    //clear entries map truoc khi init lan thu 2 tro di
    if (_mainModel.entriesOfDayNotEmpty) {
      _mainModel.clearEntriesOfDay();
    }
    _initEntriesBySchedule(schedules);
  }

  _initEntriesBySchedule(List<Schedule> schedules) {
    //khoi tao entriesOfDay, neu khoi tao roi thi dung tiep
    _mainModel.initEntriesOfDayIfNeed();

    final len = schedules.length;
    Schedule schedule;
    for (var i = 0; i < len; i++) {
      schedule = schedules[i];
      _mainModel.initEntriesIfNeed(schedule.Ngay);
      _mainModel.addScheduleToEntriesOfDay(schedule);
    }

    //sau khi đã lấy được toàn bộ lịch rồi thì sẽ tiến hành đặt thông báo lịch hàng ngày.
    _notification.initSchedulesNotification(
        _mainModel.entriesOfDay, _mainModel.msv);
    notifyListeners();
  }

  void updateSchedule() {
    _checkInternetConnectivity();
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
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
    _mainModel.initSize(size);
  }

  void launchURL() async {
    const url = 'https://m.me/hoangthang1412';
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
    print(
        'clickedOnDay ${getStringForKey(getCurrentDay)},${getStringForKey(getCurrentMonth)},$getCurrentYear from calendar_widget');
    _mainModel.clickYear = getCurrentYear;
    _mainModel.clickMonth = getCurrentMonth;
    _mainModel.clickDay = getCurrentDay;
    notifyListeners();
    if (!_mainModel.hideButtonCurrent) {
      //nếu đang hiện thì mới ẩn
      inputAction.add({'type': MainAction.reverse});
      _mainModel.hideButtonCurrent = true;
    }
  }

  void clickedOnDay(int day, int month, int year) {
    print(
        'clickedOnDay ${getStringForKey(day)},${getStringForKey(month)},$year from calendar_widget');
    _mainModel.clickYear = year;
    _mainModel.clickMonth = month;
    _mainModel.clickDay = day;
    notifyListeners();
    if (_isCurrentDay(day, month, year)) {
      if (!_mainModel.hideButtonCurrent) {
        //nếu đang hiện thì mới ẩn
        inputAction.add({'type': MainAction.reverse});
        _mainModel.hideButtonCurrent = true;
      }
    } else {
      if (_mainModel.hideButtonCurrent) {
        inputAction.add({'type': MainAction.forward});
        _mainModel.hideButtonCurrent = false;
      }
    }
  }

  bool _isCurrentDay(int d, int m, int y) {
    return d == getCurrentDay && m == getCurrentMonth && y == getCurrentYear;
  }

  void setClickDay(int clickDay) {
    _mainModel.clickDay = clickDay;
  }

  void setClickMonth(int month) {
    _mainModel.clickMonth = month;
  }

  void logOut() async {
    //kiểm tra xem còn thằng profile nào không, nếu còn thì mặc định nó lấy luôn thằng profile đầu tiên để sử dụng tiếp
    // nếu không còn thằng profile nào thì set currentmsv = '',
    //xoá hết lịch,điểm,profile của thằng msv hiện tại

//    try {
//      String value = await PlatformChannel.database
//          .invokeMethod(PlatformChannel.getAllProfile);
//      var jsonData = json.decode(value);
//      List<Profile> list = List<Profile>();
//      for (var item in jsonData) {
//        list.add(Profile.fromJson(item));
//      }

    //lấy ra toàn bộ user có trong máy
//      list.removeWhere((profile) =>
//          profile.MaSinhVien ==
//          _mainModel.msv); // xoá đi user hiện tại muốn đăng xuất
    //kiểm tra nếu list vẫn còn user thì gán vào shared msv của thằng đầu tiên luôn
    //nếu không còn thằng nào thì gán vào shared '' (empty)
//      if (list.isNotEmpty) {
//        await PlatformChannel.database.invokeMethod(
//            PlatformChannel.setCurrentMSV,
//            <String, String>{'msv': list[0].MaSinhVien});
//      } else {
    //không còn thằng nào :((
//        await PlatformChannel.database.invokeMethod(
//            PlatformChannel.setCurrentMSV, <String, String>{'msv': ''});
//      }
    //Xoá profile
//      await PlatformChannel.database.invokeMethod(
//          PlatformChannel.removeProfileByMSV,
//          <String, String>{'msv': _mainModel.msv});
    //Xoá điểm
//      await PlatformChannel.database.invokeMethod(
//          PlatformChannel.removeMarkByMSV,
//          <String, String>{'msv': _mainModel.msv});
    //Xoá lịch
//      await PlatformChannel.database.invokeMethod(
//          PlatformChannel.removeScheduleByMSV,
//          <String, String>{'msv': _mainModel.msv});
    //reset data
    _mainModel.resetData();
    notifyListeners();
    loadCurrentMSV();
    inputAction.add({
      'type': MainAction.alert_with_message,
      'data': 'Đăng xuất thành công'
    });
//    } catch (e) {
//      print('error is:$e');
    _mainModel.resetData();
    notifyListeners();
    loadCurrentMSV();
    inputAction.add({
      'type': MainAction.alert_with_message,
      'data': 'Đăng xuất bị lỗi: $e'
    });
  }

  void switchToProfile(Profile profile) async {
    // đặt lại currentmsv trong shared
    await _sharedPrefs.setCurrentMSV(profile.MaSinhVien);
//    reset data
    _mainModel.resetData();
    notifyListeners();
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
