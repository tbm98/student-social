import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:studentsocial/models/entities/schedule.dart';

part 'main_state.freezed.dart';

@freezed
abstract class MainState with _$MainState {
  const factory MainState(
  {
  @Default(0) double width,
  Size size,
  @Default(0) double itemHeight,
  @Default(0) double itemWidth,
  @Default(300) double drawerHeaderHeight,
  List<Schedule> schedules,
  @Default('Student Social') String title,
  @Default('Tên sinh viên') String name ,
  @Default('Lớp') String className ,

  Map<String, List<Schedule>> entriesOfDay,

  @Default(316) double tableHeight,// title = 25, titleday = 25, tableheight = 250 , 16 margin

  @Default(DateTime.now()) DateTime currentDate = DateTime.now();
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

  @De bool hideButtonCurrent = true;}
      ) = _MainState;
}
