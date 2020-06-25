import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/models/entities/schedule.dart';

part 'main_state.freezed.dart';

@freezed
abstract class MainState implements _$MainState {
  const MainState._();

  const factory MainState({
    double width,
    double itemWidth,
    @Default(250 / 6) double itemHeight,
    @Default(300) double drawerHeaderHeight,
    // title = 25, titleday = 25, tableheight = 250 , 16 margin
    @Default(316) double tableHeight,
    @Default('Student Social') String title,
    @Default('Tên sinh viên') String name,
    @Default('Lớp') String className,
    // mặc định msv là khách để khách có thể dùng bình thường
    @Default('guest') String msv,
    Profile profile,
    List<Profile> allProfile,
    List<Schedule> schedules,
    @Default(<String, List<Schedule>>{})
        Map<String, List<Schedule>> entriesOfDay,
    DateTime clickDate,
    DateTime currentDate,
    @Default(true) bool hideButtonCurrent,
  }) = _MainState;

  DateTime get getClickDate => clickDate ?? DateTime.now();

  DateTime get getCurrentDate => currentDate ?? DateTime.now();

  String get getName {
    if (msv == 'guest') {
      return 'Khách';
    }
    return profile?.HoTen ?? 'Họ Tên';
  }

  String get getClass => profile?.Lop ?? '';

  String get getToken => profile?.Token ?? '';

  bool get isGuest =>
      msv == null || msv == 'guest' || getName == null || getName == 'Họ Tên';

  String get getAvatarName {
    final String name = getName;
    final List<String> splitName = name.split(' ');
    return splitName.last[0];
  }

  String get keyOfCurrentEntries {
    return '${getNum(getClickDate.year)}-${getNum(getClickDate.month)}-${getNum(getClickDate.day)}';
  }

  String getNum(int n) {
    if (n < 10) {
      return '0$n';
    }
    return '$n';
  }

  static const List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple
  ];

  bool get entriesOfDayNotEmpty =>
      entriesOfDay != null && entriesOfDay.isNotEmpty;

  MainState initSize(Size size) {
    final width = size.width;
    final itemWidth = width / 7;
    return this.copyWith(width: width, itemWidth: itemWidth);
  }

  void clearEntriesOfDay() {
    entriesOfDay.clear();
  }

  MainState resetData() {
    final msv = '';
    final profile = null;
    entriesOfDay?.clear();
    return this.copyWith(msv: msv, profile: profile);
  }
}
