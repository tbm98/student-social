import 'package:flutter/material.dart';
import '../../helpers/string.dart';

class CalendarViews {
  final StringSupport _stringSupport = StringSupport();

  Widget layoutTitleCalendar(String content) {
    return Center(
      child: Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          )),
    );
  }

  final List<String> _nameDayOfWeek = [
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'CN'
  ];

  String getNameDayOfWeek(int index) {
    return _nameDayOfWeek[index];
  }

  Widget gridTitleDay(double childAspectRatio) {
    return GridView.count(
      crossAxisCount: 7,
      childAspectRatio: childAspectRatio,
      children: List.generate(7, (int index) {
        return Text(
          getNameDayOfWeek(index),
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        );
      }),
    );
  }

  Widget layoutContentNormalDay(String day) {
    return Align(
      alignment: Alignment.center,
      child: Text(day),
    );
  }

  Widget layoutContentDay(String day, Color colorText, Color colorBackground) {
    return Align(
        alignment: Alignment.center,
        child: CircleAvatar(
            backgroundColor: colorBackground,
            child: Text(
              day,
              style: TextStyle(color: colorText),
            )));
  }

  Widget layoutContentLichAmNormalDay(String lichAm) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          lichAm,
          style: TextStyle(fontSize: 8, color: Colors.grey),
        ),
      ),
    );
  }

  Widget layoutContentLichAm(String lichAm) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.green),
          child: Text(
            lichAm,
            style: const TextStyle(fontSize: 8, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget layoutContentNumberSchedule(Widget layoutNumberSchedule) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: layoutNumberSchedule,
    );
  }

  TextSpan textSpanPlus() {
    return const TextSpan(
        text: '+',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue));
  }

  TextSpan textSpanNote(int count) {
    return TextSpan(
        text: _stringSupport.getDot(count),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple));
  }

  TextSpan textSpanHoc(int count) {
    return TextSpan(
        text: _stringSupport.getDot(count),
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue));
  }

  TextSpan textSpanThi(int count) {
    return TextSpan(
        text: _stringSupport.getDot(count),
        style: const TextStyle(
          fontSize: 14,
          color: Colors.red,
        ));
  }

  Widget layoutRichTextNumberSchedule(int lt, int lh, int nt, bool hasPlus) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        children: <TextSpan>[
          textSpanThi(lt),
          textSpanHoc(lh),
          textSpanNote(nt),
          if (hasPlus) textSpanPlus() else const TextSpan(),
        ],
      ),
    );
  }
}
