import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:studentsocial/models/calendar_model.dart';
import 'package:studentsocial/models/entities/calendar_day.dart';

part 'calendar_state.freezed.dart';

@freezed
abstract class CalendarState implements _$CalendarState {
  const CalendarState._();
  const factory CalendarState({
    @Default(<int, CalendarModel>{}) Map<int, CalendarModel> calendarModels,
    @Default(12) int currentPage,
    CalendarDay currentDay,
    CalendarDay clickDay,
    @Default(12) int indexPageByClickDay,
  }) = _CalendarState;
  static const double tableHeight = 250;

  CalendarDay get getCurrentDay => currentDay ?? CalendarDay.now();
  CalendarDay get getClickDay => clickDay ?? CalendarDay.now();
}
