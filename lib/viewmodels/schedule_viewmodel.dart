import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studentsocial/models/object/calendar_day.dart';
import 'package:studentsocial/viewmodels/calendar_viewmodel.dart';

class ScheduleViewModel with ChangeNotifier {
  CalendarViewModel _calendarViewModel;
  PageController _pageController;
  int _currentPage =
      5000; //mặc định sẽ nằm ở vị trí 5000 và có tổng cộng 10000 page
  int _maxPage = 10000;

  ScheduleViewModel() {
    _pageController = PageController(initialPage: _currentPage);
    _pageController.addListener(_listenerPageView);
  }

  _listenerPageView() {
    //lắng nghe sự kiện chuyển page bằng phương thức này
    int page = _pageController.page ~/ 1;
    if (page == _pageController.page) {
      _currentPage = page;
      int delta = _currentPage - 5000;
      DateTime dateTime = delta < 0
          ? DateTime.now().subtract(Duration(days: -delta))
          : DateTime.now().add(Duration(days: delta));
      _calendarViewModel
          .listSchedulePageFinish(CalendarDay.fromDateTime(dateTime));
    }
  }

  get getPageController => _pageController;

  void onClickDay(CalendarDay calendarDay) {
    DateTime now = DateTime.now();
    int deltaDay = calendarDay
        .toDateTime()
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
    int deltaPage = 5000 + deltaDay; // 5000 là page mặc định
    _pageController.jumpToPage(deltaPage);
  }

  void addCalendarViewModel(CalendarViewModel calendarViewModel) {
    _calendarViewModel = calendarViewModel;
  }

  void onPageChanged(int value) {
    _currentPage = value;
    int delta = _currentPage - 5000;
    DateTime dateTime = delta < 0
        ? DateTime.now().subtract(Duration(days: -delta))
        : DateTime.now().add(Duration(days: delta));
    _calendarViewModel
        .listSchedulePageChange(CalendarDay.fromDateTime(dateTime));
  }

  void onClickedCurrentDay(CalendarDay calendarDay) {
    onClickDay(calendarDay);
  }
}
