import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:studentsocial/main.dart';
import 'package:studentsocial/presentation/screens/main/main_state_notifier.dart';
import 'package:studentsocial/viewmodels/calendar_state.dart';
import 'package:studentsocial/viewmodels/schedule_state_notifier.dart';

import '../models/calendar_model.dart';
import '../models/entities/calendar_day.dart';
import '../models/entities/schedule.dart';
import '../presentation/screens/main/main_state_notifier.dart';

final calendarStateNotifier = StateNotifierProvider((ref) {
  return CalendarStateNotifier(ref.read(mainStateNotifier).value);
});

class CalendarStateNotifier extends StateNotifier<CalendarState> {
  CalendarStateNotifier(MainStateNotifier mainStateNotifier)
      : super(const CalendarState()) {
    _mainStateNotifier = mainStateNotifier;
    pageController = PageController(initialPage: 12, viewportFraction: 0.99);
  }

  PageController pageController;

  MainStateNotifier _mainStateNotifier;

  CalendarDay get clickDay => state.clickDay;

  CalendarDay get currentDay => state.currentDay;

  int getNumberOfMonth(CalendarDay calendar) {
    return calendar.year * 12 + calendar.month;
  }

  void onClickDay(CalendarDay day) {
    final indexPageByClickDay = state
        .currentPage; // nếu click vào ngày ở trên calendarview thì cập nhật lại indexpage = current page, coi như reset trạng thái của indexpage
    final clickDay = day;
    state = state.copyWith(
        indexPageByClickDay: indexPageByClickDay, clickDay: clickDay);
    _mainStateNotifier.clickedOnDay(day.day, day.month, day.year);
  }

  void listSchedulePageChange(CalendarDay day) {
    final int numberDay = getNumberOfMonth(day);
    final int numberClickDay = getNumberOfMonth(state.getClickDay);
    int indexPageByClickDay = state.indexPageByClickDay;
    //nếu là vuốt thì cự li thay đổi của tháng chỉ là 1 nên chỉ cần check tháng và tăng hoặc giảm 1 là dc
    if (numberDay > numberClickDay) {
      //nhảy sang tháng tiếp theo
      indexPageByClickDay++;
    } else if (numberDay < numberClickDay) {
      //nhảy sang tháng trước
      indexPageByClickDay--;
    }
    pageController.jumpToPage(indexPageByClickDay);
    final clickDay = day;
    state = state.copyWith(
        indexPageByClickDay: indexPageByClickDay, clickDay: clickDay);
    _mainStateNotifier.clickedOnDay(day.day, day.month, day.year);
  }

  int getDay(int index, int indexPage) {
    return (state.calendarModels[indexPage].maxDay -
        ((state.calendarModels[indexPage].indexDayOfWeek -
                1 -
                1 +
                state.calendarModels[indexPage].maxDay) -
            (index)));
  }

  void setIndexPage(int indexPage) {
    final calendarModels = <int, CalendarModel>{}..addAll(state.calendarModels);
    calendarModels[indexPage] = CalendarModel();
    calendarModels[indexPage].setIndexPage(indexPage);
    state = state.copyWith(calendarModels: calendarModels);
  }

  String getKeyOfEntri(int month, int day, int indexPage) {
    // return with format dd/mm/yyyy
    return '${getStringForKey(day)}/${getStringForKey(month)}/${state.calendarModels[indexPage].year}';
  }

  String getStringForKey(int i) {
    if (i < 10) {
      return '0$i';
    }
    return i.toString();
  }

  void setIndexPageByChanged(int index) {
    state = state.copyWith(currentPage: index);
    //người dùng vuốt sang trang khác => hiện thị nút hiện tại cho người ta quay về
    _mainStateNotifier.calendarPageChanged(index);
  }

  String getTitleCalendar(int indexPage) {
    return state.calendarModels[indexPage].titleCalendar;
  }

  void jumpToCurrentPage() {
    pageController.jumpToPage(state.currentPage);
  }

  List<CalendarDay> getListCalendarDay(int indexPage) {
    return state.calendarModels[indexPage].listCalendarDays;
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

  List<int> calculateNumberSchedules(List<Schedule> entries) {
    int lichHoc = 0, lichThi = 0, note = 0;
    if (entries != null) {
      entries.forEach((Schedule entri) {
        if (entri.LoaiLich == 'LichHoc') {
          lichHoc++;
        }
        if (entri.LoaiLich == 'LichThi') {
          lichThi++;
        }
        if (entri.LoaiLich == 'Note') {
          note++;
        }
      });
    }
    return [lichThi, lichHoc, note];
  }

  void onClickedCurrentDay(CalendarDay calendarDay) {
    state = state.copyWith(currentPage: 12);
    onClickDay(calendarDay);
    jumpToCurrentPage();
  }

  void addMainStateNotifier(MainStateNotifier mainStateNotifier) {
    _mainStateNotifier = mainStateNotifier;
  }
}
