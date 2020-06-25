// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'login_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$LoginStateTearOff {
  const _$LoginStateTearOff();

  _LoginState call(
      {String semester,
      String token,
      String mark,
      String msv,
      Profile profile,
      ScheduleResult lichHoc,
      ScheduleResult lichThi}) {
    return _LoginState(
      semester: semester,
      token: token,
      mark: mark,
      msv: msv,
      profile: profile,
      lichHoc: lichHoc,
      lichThi: lichThi,
    );
  }
}

// ignore: unused_element
const $LoginState = _$LoginStateTearOff();

mixin _$LoginState {
  String get semester;
  String get token;
  String get mark;
  String get msv;
  Profile get profile;
  ScheduleResult get lichHoc;
  ScheduleResult get lichThi;

  $LoginStateCopyWith<LoginState> get copyWith;
}

abstract class $LoginStateCopyWith<$Res> {
  factory $LoginStateCopyWith(
          LoginState value, $Res Function(LoginState) then) =
      _$LoginStateCopyWithImpl<$Res>;
  $Res call(
      {String semester,
      String token,
      String mark,
      String msv,
      Profile profile,
      ScheduleResult lichHoc,
      ScheduleResult lichThi});
}

class _$LoginStateCopyWithImpl<$Res> implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._value, this._then);

  final LoginState _value;
  // ignore: unused_field
  final $Res Function(LoginState) _then;

  @override
  $Res call({
    Object semester = freezed,
    Object token = freezed,
    Object mark = freezed,
    Object msv = freezed,
    Object profile = freezed,
    Object lichHoc = freezed,
    Object lichThi = freezed,
  }) {
    return _then(_value.copyWith(
      semester: semester == freezed ? _value.semester : semester as String,
      token: token == freezed ? _value.token : token as String,
      mark: mark == freezed ? _value.mark : mark as String,
      msv: msv == freezed ? _value.msv : msv as String,
      profile: profile == freezed ? _value.profile : profile as Profile,
      lichHoc: lichHoc == freezed ? _value.lichHoc : lichHoc as ScheduleResult,
      lichThi: lichThi == freezed ? _value.lichThi : lichThi as ScheduleResult,
    ));
  }
}

abstract class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(
          _LoginState value, $Res Function(_LoginState) then) =
      __$LoginStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {String semester,
      String token,
      String mark,
      String msv,
      Profile profile,
      ScheduleResult lichHoc,
      ScheduleResult lichThi});
}

class __$LoginStateCopyWithImpl<$Res> extends _$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(
      _LoginState _value, $Res Function(_LoginState) _then)
      : super(_value, (v) => _then(v as _LoginState));

  @override
  _LoginState get _value => super._value as _LoginState;

  @override
  $Res call({
    Object semester = freezed,
    Object token = freezed,
    Object mark = freezed,
    Object msv = freezed,
    Object profile = freezed,
    Object lichHoc = freezed,
    Object lichThi = freezed,
  }) {
    return _then(_LoginState(
      semester: semester == freezed ? _value.semester : semester as String,
      token: token == freezed ? _value.token : token as String,
      mark: mark == freezed ? _value.mark : mark as String,
      msv: msv == freezed ? _value.msv : msv as String,
      profile: profile == freezed ? _value.profile : profile as Profile,
      lichHoc: lichHoc == freezed ? _value.lichHoc : lichHoc as ScheduleResult,
      lichThi: lichThi == freezed ? _value.lichThi : lichThi as ScheduleResult,
    ));
  }
}

class _$_LoginState extends _LoginState with DiagnosticableTreeMixin {
  const _$_LoginState(
      {this.semester,
      this.token,
      this.mark,
      this.msv,
      this.profile,
      this.lichHoc,
      this.lichThi})
      : super._();

  @override
  final String semester;
  @override
  final String token;
  @override
  final String mark;
  @override
  final String msv;
  @override
  final Profile profile;
  @override
  final ScheduleResult lichHoc;
  @override
  final ScheduleResult lichThi;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LoginState(semester: $semester, token: $token, mark: $mark, msv: $msv, profile: $profile, lichHoc: $lichHoc, lichThi: $lichThi)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LoginState'))
      ..add(DiagnosticsProperty('semester', semester))
      ..add(DiagnosticsProperty('token', token))
      ..add(DiagnosticsProperty('mark', mark))
      ..add(DiagnosticsProperty('msv', msv))
      ..add(DiagnosticsProperty('profile', profile))
      ..add(DiagnosticsProperty('lichHoc', lichHoc))
      ..add(DiagnosticsProperty('lichThi', lichThi));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _LoginState &&
            (identical(other.semester, semester) ||
                const DeepCollectionEquality()
                    .equals(other.semester, semester)) &&
            (identical(other.token, token) ||
                const DeepCollectionEquality().equals(other.token, token)) &&
            (identical(other.mark, mark) ||
                const DeepCollectionEquality().equals(other.mark, mark)) &&
            (identical(other.msv, msv) ||
                const DeepCollectionEquality().equals(other.msv, msv)) &&
            (identical(other.profile, profile) ||
                const DeepCollectionEquality()
                    .equals(other.profile, profile)) &&
            (identical(other.lichHoc, lichHoc) ||
                const DeepCollectionEquality()
                    .equals(other.lichHoc, lichHoc)) &&
            (identical(other.lichThi, lichThi) ||
                const DeepCollectionEquality().equals(other.lichThi, lichThi)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(semester) ^
      const DeepCollectionEquality().hash(token) ^
      const DeepCollectionEquality().hash(mark) ^
      const DeepCollectionEquality().hash(msv) ^
      const DeepCollectionEquality().hash(profile) ^
      const DeepCollectionEquality().hash(lichHoc) ^
      const DeepCollectionEquality().hash(lichThi);

  @override
  _$LoginStateCopyWith<_LoginState> get copyWith =>
      __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);
}

abstract class _LoginState extends LoginState {
  const _LoginState._() : super._();
  const factory _LoginState(
      {String semester,
      String token,
      String mark,
      String msv,
      Profile profile,
      ScheduleResult lichHoc,
      ScheduleResult lichThi}) = _$_LoginState;

  @override
  String get semester;
  @override
  String get token;
  @override
  String get mark;
  @override
  String get msv;
  @override
  Profile get profile;
  @override
  ScheduleResult get lichHoc;
  @override
  ScheduleResult get lichThi;
  @override
  _$LoginStateCopyWith<_LoginState> get copyWith;
}
