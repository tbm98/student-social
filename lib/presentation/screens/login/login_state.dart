import 'package:studentsocial/models/entities/login.dart';
import 'package:studentsocial/models/entities/profile.dart';
import 'package:studentsocial/models/entities/schedule.dart';
import 'package:studentsocial/models/entities/semester.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'login_state.freezed.dart';

@freezed
abstract class LoginState implements _$LoginState {
  const LoginState._();

  const factory LoginState(
      {String semester,
      String token,
      String mark,
      String msv,
      Profile profile,
      ScheduleResult lichHoc,
      ScheduleResult lichThi}) = _LoginState;
}
