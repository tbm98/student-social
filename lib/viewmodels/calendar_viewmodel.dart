import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studentsocial/models/calendar_model.dart';
import 'package:studentsocial/models/entities/calendar_day.dart';
import 'package:studentsocial/viewmodels/main_viewmodel.dart';

class CalendarViewModel with ChangeNotifier {
  MainViewModel _mainViewModel;
  Map<int, CalendarModel> _calendarModels;
  PageController pageViewController =
      new PageController(initialPage: 12, viewportFraction: 0.99);
  final double tableHeight = 250;
  int currentPage = 12;

  CalendarViewModel() {
    _calendarModels = Map<int, CalendarModel>();
  }

  get getTableHeight => tableHeight;

  get getPageViewController => pageViewController;

  void addMainViewModel(MainViewModel mainViewModel) {
    _mainViewModel = mainViewModel;
  }

  CalendarDay currentDay = CalendarDay.now();

  CalendarDay clickDay = CalendarDay.now();

  int indexPageByClickDay = 12;

  int getNumberOfMonth(CalendarDay calendar) {
    return calendar.year * 12 + calendar.month;
  }

  onClickDay(CalendarDay day) {
    indexPageByClickDay =
        currentPage; // nếu click vào ngày ở trên calendarview thì cập nhật lại indexpage = current page, coi như reset trạng thái của indexpage
    clickDay = day;
    notifyListeners();
    _mainViewModel.clickedOnDay(day.day, day.month, day.year);
  }

  void listSchedulePageFinish(CalendarDay calendarDay) {}

  listSchedulePageChange(CalendarDay day) {
    int numberDay = getNumberOfMonth(day);
    int numberClickDay = getNumberOfMonth(clickDay);
    //nếu là vuốt thì cự li thay đổi của tháng chỉ là 1 nên chỉ cần check tháng và tăng hoặc giảm 1 là dc
    if (numberDay > numberClickDay) {
      //nhảy sang tháng tiếp theo
      indexPageByClickDay++;
    } else if (numberDay < numberClickDay) {
      //nhảy sang tháng trước
      indexPageByClickDay--;
    }
    pageViewController.jumpToPage(indexPageByClickDay);
    clickDay = day;
    notifyListeners();
    _mainViewModel.clickedOnDay(day.day, day.month, day.year);
  }

  int getDay(int index, int indexPage) {
    return (_calendarModels[indexPage].maxDay -
        ((_calendarModels[indexPage].indexDayOfWeek -
                1 -
                1 +
                _calendarModels[indexPage].maxDay) -
            (index)));
  }

  void setIndexPage(int indexPage) {
    _calendarModels[indexPage] = CalendarModel();
    _calendarModels[indexPage].setIndexPage(indexPage);
  }

  String getKeyOfEntri(int month, int day, int indexPage) {
    return '${_calendarModels[indexPage].year}-${getStringForKey(month)}-${getStringForKey(day)}';
  }

  String getStringForKey(int i) {
    if (i < 10) {
      return '0$i';
    }
    return i.toString();
  }

  void setIndexPageByChanged(int index) {
    currentPage = index;
      //người dùng vuốt sang trang khác => hiện thị nút hiện tại cho người ta quay về
    _mainViewModel.calendarPageChanged(index);
  }

  String getTitleCalendar(int indexPage) {
    return _calendarModels[indexPage].titleCalendar;
  }

  void jumpToCurrentPage() {
    pageViewController.jumpToPage(currentPage);
  }

  List<CalendarDay> getListCalendarDay(int indexPage) {
    return _calendarModels[indexPage].listCalendarDays;
  }

  String getLichAmCurrentDay(List<int> lichAm) {
    return '${lichAm[0]}/${lichAm[1]}';
  }

  String getLichAm(List<int> lichAm) {
    if (lichAm[0] == 1) {
      return '${lichAm[0]}/${lichAm[1]}';
    } else {
      return lichAm[0].toString();
    }
  }

  List<int> getNumberSchedules(int lichThi, int lichHoc, int note) {
    // se la ••••+
    int lt = 0, lh = 0, nt = 0;
    if (lichThi >= 4) {
      lt = 4;
    } else {
      lt = lichThi;
    }
    if (lichHoc + lt >= 4) {
      lh = 4 - lt;
    } else {
      lh = lichHoc;
    }
    if (note + lt + lh >= 4) {
      nt = 4 - lt - lh;
    } else {
      nt = note;
    }
    lt = max(lt, 0);
    lh = max(lh, 0);
    nt = max(nt, 0);
    return [lt, lh, nt];
  }

  List<int> calculateNumberSchedules(entries) {
    int lichHoc = 0, lichThi = 0, note = 0;
    if (entries != null)
      entries.forEach((entri) {
        if (entri.LoaiLich == "LichHoc") {
          lichHoc++;
        }
        if (entri.LoaiLich == "LichThi") {
          lichThi++;
        }
        if (entri.LoaiLich == "Note") {
          note++;
        }
      });
    return [lichThi, lichHoc, note];
  }

  void onClickedCurrentDay(CalendarDay calendarDay) {
    currentPage = 12;
    onClickDay(calendarDay);
    jumpToCurrentPage();
  }
}
