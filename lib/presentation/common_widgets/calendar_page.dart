import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsocial/helpers/logging.dart';

import '../../models/entities/calendar_day.dart';
import '../../models/entities/schedule.dart';
import '../../viewmodels/calendar_viewmodel.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import '../screens/main/main_notifier.dart';
import 'calendar_views.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with CalendarViews {
  MainNotifier _mainViewModel;
  CalendarViewModel _calendarViewModel;
  ScheduleViewModel _listScheduleViewModel;

  void _initViewModel() {
    _mainViewModel = Provider.of<MainNotifier>(context);
    _calendarViewModel = Provider.of<CalendarViewModel>(context);
    _calendarViewModel.addMainViewModel(_mainViewModel);
    _listScheduleViewModel = Provider.of<ScheduleViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    _initViewModel();
    return PageView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 24,
      controller: _calendarViewModel.getPageViewController,
      itemBuilder: (BuildContext context, int index) {
        return _layoutItemCalendar(index);
      },
      onPageChanged: (int index) {
        _calendarViewModel.setIndexPageByChanged(index);
      },
    );
  }

  Widget _layoutItemCalendar(int indexPage) {
    _calendarViewModel.setIndexPage(indexPage);
    return Container(
      margin: const EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: Colors.white),
      child: Column(
        children: <Widget>[
          layoutTitleCalendar(_calendarViewModel.getTitleCalendar(indexPage)),
          _layoutTitleDaysOfWeek(),
          Container(
            width: _mainViewModel.getWidth,
            height: _calendarViewModel.getTableHeight,
            child: GridView(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: _mainViewModel.getItemWidth /
                      _mainViewModel.getItemHeight),
              children: _getListItemDay(indexPage),
            ),
          ),
        ],
      ),
    );
  }

  Widget _layoutTitleDaysOfWeek() {
    return Container(
      width: _mainViewModel.getWidth,
      height: 25,
      child: gridTitleDay(
          _mainViewModel.getItemWidth / _mainViewModel.getItemHeight),
    );
  }

  List<Widget> _getListItemDay(int indexPage) {
    final List<Widget> _items = <Widget>[];
    for (int i = 0; i < 42; i++) {
      _items.add(Center(child: layoutOfDay(indexPage, i)));
    }
    return _items;
  }

  Widget layoutOfDay(int indexPage, int index) {
    if (_calendarViewModel.getListCalendarDay(indexPage)[index].isEmpty()) {
      //nhung ngay khong trong pham vi
      return Container();
    }
    return layoutDayByType(indexPage, index);
  }

  Widget layoutDayByType(int indexPage, int index) {
    final CalendarDay calendarDay =
        _calendarViewModel.getListCalendarDay(indexPage)[index];
    if (calendarDay.equal(_calendarViewModel.currentDay)) {
//      return CalendarTile();
      return currentDay(indexPage, index);
    }
    if (calendarDay.equal(_calendarViewModel.clickDay)) {
      return currentDayByClick(indexPage, index);
    }
    return normalDay(indexPage, index);
  }

  Widget currentDay(int indexPage, int index) {
    final CalendarDay calendarDay =
        _calendarViewModel.getListCalendarDay(indexPage)[index];
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        _calendarViewModel.onClickDay(calendarDay);
        _listScheduleViewModel.onClickDay(calendarDay);
      },
      child: Stack(
        children: <Widget>[
          layoutContentDay(
              calendarDay.day.toString(), Colors.red, Colors.black12),
          layoutContentLichAm(
              _calendarViewModel.getLichAmCurrentDay(calendarDay.lichAm)),
          layoutContentNumberSchedule(layoutNumberSchedule(indexPage, index))
        ],
      ),
    );
  }

  Widget currentDayByClick(int indexPage, int index) {
    final CalendarDay calendarDay =
        _calendarViewModel.getListCalendarDay(indexPage)[index];
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        _calendarViewModel.onClickDay(calendarDay);
        _listScheduleViewModel.onClickDay(calendarDay);
      },
      child: Stack(
        children: <Widget>[
          layoutContentDay(
              calendarDay.day.toString(), Colors.black, Colors.black12),
          layoutContentLichAm(
              _calendarViewModel.getLichAmCurrentDay(calendarDay.lichAm)),
          layoutContentNumberSchedule(layoutNumberSchedule(indexPage, index))
        ],
      ),
    );
  }

  Widget normalDay(int indexPage, int index) {
    final CalendarDay calendarDay =
        _calendarViewModel.getListCalendarDay(indexPage)[index];
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        _calendarViewModel.onClickDay(calendarDay);
        _listScheduleViewModel.onClickDay(calendarDay);
      },
      child: Stack(
        children: <Widget>[
          layoutContentNormalDay(calendarDay.day.toString()),
          layoutContentLichAmNormalDay(
              _calendarViewModel.getLichAm(calendarDay.lichAm)),
          layoutContentNumberSchedule(layoutNumberSchedule(indexPage, index))
        ],
      ),
    );
  }

  Widget layoutNumberSchedule(int indexPage, int index) {
    final CalendarDay calendarDay =
        _calendarViewModel.getListCalendarDay(indexPage)[index];
    //• 1 cham the thien 1 lich
    final String keyOfEntri = _calendarViewModel.getKeyOfEntri(
        calendarDay.month, calendarDay.day, indexPage);
    if (_mainViewModel.getEntriesOfDay != null) {
      final List<Schedule> entries = _mainViewModel.getEntriesOfDay[keyOfEntri];
//    lọc những tiết bị trùng
//      if (entries != null && entries.isNotEmpty)
//        for (int i = 0; i < entries.length - 1; i++) {
//          for (int j = i + 1; j < entries.length; j++) {
//            if (entries[j].equals(entries[i])) {
//              entries.removeAt(j);
//              j--;
//            }
//          }
//        }
      final List<int> numberSchedules =
          _calendarViewModel.calculateNumberSchedules(entries);
      if (numberSchedules[0] == 0 &&
          numberSchedules[1] == 0 &&
          numberSchedules[2] == 0) {
        return Container();
      }

      return getLayoutNumberSchedule(
          numberSchedules[0], numberSchedules[1], numberSchedules[2]);
    }
    return Container();
  }

  Widget getLayoutNumberSchedule(int lichThi, int lichHoc, int note) {
    if (lichThi + lichHoc + note >= 6) {
      final List<int> listNumber =
          _calendarViewModel.getNumberSchedules(lichThi, lichHoc, note);
      return layoutRichTextNumberSchedule(
          listNumber[0], listNumber[1], listNumber[2], true);
    } else {
      return layoutRichTextNumberSchedule(lichThi, lichHoc, note, false);
    }
  }
}
