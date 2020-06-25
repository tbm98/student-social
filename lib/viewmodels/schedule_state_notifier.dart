import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:studentsocial/viewmodels/schedule_state.dart';

import '../models/entities/calendar_day.dart';
import 'calendar_state_notifier.dart';

final scheduleStateNotifier = StateNotifierProvider((ref) {
  return ScheduleStateNotifier(ref.read(calendarStateNotifier).value);
});

class ScheduleStateNotifier extends StateNotifier<ScheduleState> {
  ScheduleStateNotifier(CalendarStateNotifier calendarStateNotifier)
      : super(const ScheduleState()) {
    _calendarStateNotifier = calendarStateNotifier;
    pageController = PageController(initialPage: state.currentPage);
    pageController.addListener(_listenerPageView);
    print(pageController.hasListeners);
  }

  PageController pageController;

  CalendarStateNotifier _calendarStateNotifier;

  void _listenerPageView() {
    //lắng nghe sự kiện chuyển page bằng phương thức này
    final int page = pageController.page ~/ 1;
    if (page == pageController.page) {
      state = state.copyWith(currentPage: page);
      final int delta = state.currentPage - 5000;
      final DateTime dateTime = delta < 0
          ? DateTime.now().subtract(Duration(days: -delta))
          : DateTime.now().add(Duration(days: delta));
    }
  }

  void onClickDay(CalendarDay calendarDay) {
    final DateTime now = DateTime.now();
    final int deltaDay = calendarDay
        .toDateTime()
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    final int deltaPage = 5000 + deltaDay; // 5000 là page mặc định
    pageController.jumpToPage(deltaPage);
  }

  void onPageChanged(int value) {
    state = state.copyWith(currentPage: value);
    final int delta = state.currentPage - 5000;
    final DateTime dateTime = delta < 0
        ? DateTime.now().subtract(Duration(days: -delta))
        : DateTime.now().add(Duration(days: delta));
    _calendarStateNotifier
        .listSchedulePageChange(CalendarDay.fromDateTime(dateTime));
//    calendarStateNotifier.read(context).listSchedulePageChange(CalendarDay.fromDateTime(dateTime));
  }

  void onClickedCurrentDay(CalendarDay calendarDay) {
    onClickDay(calendarDay);
  }

  void addCalendarStateNotifier(CalendarStateNotifier calendarStateNotifier) {
    _calendarStateNotifier = calendarStateNotifier;
  }
}
