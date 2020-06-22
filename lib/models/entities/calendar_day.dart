import '../../helpers/viet_calendar.dart';

enum DayType { normal, current, click }

class CalendarDay {
  CalendarDay({this.day, this.month, this.year}) {
    _initLichAm();
  }
  factory CalendarDay.now() {
    final DateTime date = DateTime.now();
    return CalendarDay(day: date.day, month: date.month, year: date.year);
  }
  factory CalendarDay.empty() {
    return CalendarDay(day: 0, month: 0, year: 0);
  }

  factory CalendarDay.fromDateTime(DateTime date) {
    return CalendarDay(day: date.day, month: date.month, year: date.year);
  }
  final int day;

  final int month;
  final int year;
  List<int> lichAm = <int>[];

  DateTime toDateTime() {
    return DateTime(year, month, day);
  }

  void _initLichAm() {
    lichAm = VietCalendar.getInstance().lichAm(day, month, year);
  }

  bool equal(CalendarDay day2) {
    return day2.day == day && day2.month == month && day2.year == year;
  }

  bool isEmpty() {
    return day == 0 && month == 0 && year == 0;
  }
}
