import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../models/entities/profile.dart';
import '../../../models/entities/schedule.dart';

class MainModel {
  double width = 0;
  Size size;
  double itemHeight = 0;
  double itemWidth = 0;
  double drawerHeaderHeight = 300;
  List<Schedule> schedules;
  String title = 'Student Social';
  String name = 'Tên sinh viên';
  String className = 'Lớp';

  Map<String, List<Schedule>> entriesOfDay;

  double tableHeight =
      316; // title = 25, titleday = 25, tableheight = 250 , 16 margin

  final DateTime currentDate = DateTime.now();
  DateTime stateDate;

  int clickDay = DateTime.now().day;
  int clickMonth = DateTime.now().month;
  int clickYear = DateTime.now().year;
  int currentDay = DateTime.now().day;
  int currentMonth = DateTime.now().month;
  int currentYear = DateTime.now().year;

  String msv =
      'guest'; // mặc định msv là khách để khách có thể dùng bình thường

  Profile profile;

  List<Profile> allProfile;

  bool hideButtonCurrent = true;

  String get keyOfCurrentEntries =>
      '${getNum(clickYear)}-${getNum(clickMonth)}-${getNum(clickDay)}';

  String getNum(int n) {
    if (n < 10) {
      return '0$n';
    }
    return '$n';
  }

  List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple
  ];

  bool get entriesOfDayNotEmpty =>
      entriesOfDay != null && entriesOfDay.isNotEmpty;

  void initSize(Size s) {
    size = s;
    width = size.width;
//    this._height = this._size.height;
    itemHeight = 250 / 6;
    itemWidth = width / 7;
  }

  void clearEntriesOfDay() {
    entriesOfDay.clear();
  }

  void initEntriesOfDayIfNeed() {
    entriesOfDay ??= <String, List<Schedule>>{};
  }

  void initEntriesIfNeed(String ngay) {
    if (entriesOfDay[ngay] == null) {
      entriesOfDay[ngay] = <Schedule>[];
      // neu ngay cua entri nay chua co lich thi phai khoi tao trong map 1 list de luu lai duoc,
      //neu co roi thi thoi dung tiep
    }
  }

  void addScheduleToEntriesOfDay(Schedule lich) {
    entriesOfDay[lich.getNgay].add(lich);
  }

  DateTime get getDateCurrentClick => DateTime(clickYear, clickMonth, clickDay);

  void resetData() {
    msv = '';
    profile = null;
    entriesOfDay?.clear();
  }
}
