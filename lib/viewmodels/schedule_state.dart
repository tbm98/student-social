import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'schedule_state.freezed.dart';

@freezed
abstract class ScheduleState implements _$ScheduleState {
  const ScheduleState._();
  const factory ScheduleState({
    //mặc định sẽ nằm ở vị trí 5000 và có tổng cộng 10000 page
    @Default(5000) int currentPage,
  }) = _ScheduleState;

  static const int _maxPage = 10000;
}
