import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studentsocial/helpers/logging.dart';
import 'package:studentsocial/main.dart';

import '../../models/entities/calendar_day.dart';
import '../../models/entities/schedule.dart';
import '../../viewmodels/calendar_state_notifier.dart';
import '../../viewmodels/schedule_state_notifier.dart';
import '../screens/main/main_state_notifier.dart';
import 'calendar_views.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with CalendarViews {
  @override
  Widget build(BuildContext context) {
    return Consumer((context, read) {
      return PageView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: 24,
        controller: read(calendarStateNotifier).pageController,
        itemBuilder: (BuildContext context, int index) {
          return _layoutItemCalendar(index);
        },
        onPageChanged: (int index) {
          read(calendarStateNotifier).setIndexPageByChanged(index);
        },
      );
    });
  }

  Widget _layoutItemCalendar(int indexPage) {
    return Consumer((context, read) {
      read(calendarStateNotifier).setIndexPage(indexPage);
      return Container(
        margin: const EdgeInsets.only(left: 4, right: 4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.white),
        child: Column(
          children: <Widget>[
            layoutTitleCalendar(
                read(calendarStateNotifier).getTitleCalendar(indexPage)),
            _layoutTitleDaysOfWeek(),
            Container(
              width: read(mainStateNotifier).width,
              height: read(mainStateNotifier).tableHeight,
              child: GridView(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: read(mainStateNotifier).itemWidth /
                        read(mainStateNotifier).itemHeight),
                children: _getListItemDay(indexPage),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _layoutTitleDaysOfWeek() {
    return Consumer((context, read) {
      return Container(
        width: read(mainStateNotifier).width,
        height: 25,
        child: gridTitleDay(read(mainStateNotifier).itemWidth /
            read(mainStateNotifier).itemHeight),
      );
    });
  }

  List<Widget> _getListItemDay(int indexPage) {
    final List<Widget> _items = <Widget>[];
    for (int i = 0; i < 42; i++) {
      _items.add(Center(child: layoutOfDay(indexPage, i)));
    }
    return _items;
  }

  Widget layoutOfDay(int indexPage, int index) {
    return Consumer((context, read) {
      if (read(calendarStateNotifier)
          .getListCalendarDay(indexPage)[index]
          .isEmpty()) {
        //nhung ngay khong trong pham vi
        return Container();
      }
      return layoutDayByType(indexPage, index);
    });
  }

  Widget layoutDayByType(int indexPage, int index) {
    return Consumer((context, read) {
      final calendarNotifier = read(calendarStateNotifier);
      final CalendarDay calendarDay =
          calendarNotifier.getListCalendarDay(indexPage)[index];
      logs('calendarDay: ${calendarDay.toDateTime()}');
      if (calendarDay.equal(calendarNotifier.state.getCurrentDay)) {
//      return CalendarTile();
        return currentDay(indexPage, index);
      }
      if (calendarDay.equal(calendarNotifier.state.getClickDay)) {
        return currentDayByClick(indexPage, index);
      }
      return normalDay(indexPage, index);
    });
  }

  Widget currentDay(int indexPage, int index) {
    return Consumer((context, read) {
      final CalendarDay calendarDay =
          read(calendarStateNotifier).getListCalendarDay(indexPage)[index];
      logs('calendarDay: $calendarDay');
      return InkResponse(
        enableFeedback: true,
        onTap: () {
          calendarStateNotifier.read(context).onClickDay(calendarDay);
          scheduleStateNotifier.read(context).onClickDay(calendarDay);
        },
        child: Stack(
          children: <Widget>[
            layoutContentDay(
                calendarDay.day.toString(), Colors.red, Colors.black12),
            layoutContentLichAm(read(calendarStateNotifier)
                .getLichAmCurrentDay(calendarDay.lichAm)),
            layoutContentNumberSchedule(layoutNumberSchedule(indexPage, index))
          ],
        ),
      );
    });
  }

  Widget currentDayByClick(int indexPage, int index) {
    return Consumer((context, read) {
      final CalendarDay calendarDay =
          read(calendarStateNotifier).getListCalendarDay(indexPage)[index];
      return InkResponse(
        enableFeedback: true,
        onTap: () {
          read(calendarStateNotifier).onClickDay(calendarDay);
          read(scheduleStateNotifier).onClickDay(calendarDay);
        },
        child: Stack(
          children: <Widget>[
            layoutContentDay(
                calendarDay.day.toString(), Colors.black, Colors.black12),
            layoutContentLichAm(read(calendarStateNotifier)
                .getLichAmCurrentDay(calendarDay.lichAm)),
            layoutContentNumberSchedule(layoutNumberSchedule(indexPage, index))
          ],
        ),
      );
    });
  }

  Widget normalDay(int indexPage, int index) {
    return Consumer((context, read) {
      final CalendarDay calendarDay =
          read(calendarStateNotifier).getListCalendarDay(indexPage)[index];
      return InkResponse(
        enableFeedback: true,
        onTap: () {
          calendarStateNotifier.read(context).onClickDay(calendarDay);
          scheduleStateNotifier.read(context).onClickDay(calendarDay);
        },
        child: Stack(
          children: <Widget>[
            layoutContentNormalDay(calendarDay.day.toString()),
            layoutContentLichAmNormalDay(
                read(calendarStateNotifier).getLichAm(calendarDay.lichAm)),
            layoutContentNumberSchedule(layoutNumberSchedule(indexPage, index))
          ],
        ),
      );
    });
  }

  Widget layoutNumberSchedule(int indexPage, int index) {
    return Consumer((context, read) {
      final CalendarDay calendarDay =
          read(calendarStateNotifier).getListCalendarDay(indexPage)[index];
      //• 1 cham the thien 1 lich
      final String keyOfEntri = read(calendarStateNotifier)
          .getKeyOfEntri(calendarDay.month, calendarDay.day, indexPage);
      if (read(mainStateNotifier).entriesOfDay != null) {
        final List<Schedule> entries =
            read(mainStateNotifier).entriesOfDay[keyOfEntri];
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
            read(calendarStateNotifier).calculateNumberSchedules(entries);
        if (numberSchedules[0] == 0 &&
            numberSchedules[1] == 0 &&
            numberSchedules[2] == 0) {
          return Container();
        }

        return getLayoutNumberSchedule(
            numberSchedules[0], numberSchedules[1], numberSchedules[2]);
      }
      return Container();
    });
  }

  Widget getLayoutNumberSchedule(int lichThi, int lichHoc, int note) {
    return Consumer((context, read) {
      if (lichThi + lichHoc + note >= 6) {
        final List<int> listNumber = read(calendarStateNotifier)
            .getNumberSchedules(lichThi, lichHoc, note);
        return layoutRichTextNumberSchedule(
            listNumber[0], listNumber[1], listNumber[2], true);
      } else {
        return layoutRichTextNumberSchedule(lichThi, lichHoc, note, false);
      }
    });
  }
}
