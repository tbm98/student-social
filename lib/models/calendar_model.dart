import 'package:studentsocial/support/date.dart';

import 'object/calendar_day.dart';

class CalendarModel {
  final DateSupport dateSupport = DateSupport();
  int indexPage;

  List<CalendarDay> listCalendarDays = List<CalendarDay>();

  //

  int get currentDay {
    return dateSupport.getDay();
  }

  int get currentMonth {
    return dateSupport.getMonth();
  }

  int get currentYear {
    return dateSupport.getYear();
  }

  int get month {
    return dateSupport.getMonthByIndex(indexPage, 1);
  }

  int get year {
    return dateSupport.getMonthByIndex(indexPage, 2);
  }

  int get maxDay {
    return dateSupport.getMaxDayOfMonth(year, month);
  }

  int get indexDayOfWeek {
    return dateSupport.getIndexDayOfWeek(year, month);
  }

  String get titleCalendar => 'Tháng $month - $year';

  bool isDayInScope(int index) {
    return index >= indexDayOfWeek - 1 && index < indexDayOfWeek - 1 + maxDay;
  }

  int getDay(int index) {
    return (maxDay - ((indexDayOfWeek - 1 - 1 + maxDay) - (index)));
  }

  void setIndexPage(int indexPage) {
    this.indexPage = indexPage;
    //tinh toan lich am/duong
    for (int i = 0; i < 42; i++) {
      if (isDayInScope(i)) {
        //ngày này trong phạm vi hiển thị của tháng
        int day = getDay(i);
        listCalendarDays.add(CalendarDay(day: day, month: month, year: year));
      } else {
        listCalendarDays.add(CalendarDay.empty());
        //ngày này ngoài phạm vi nên sẽ init dữ liệu gỉa
      }
    }
  }
}
