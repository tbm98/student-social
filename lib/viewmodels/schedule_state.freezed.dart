// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'schedule_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$ScheduleStateTearOff {
  const _$ScheduleStateTearOff();

  _ScheduleState call({int currentPage = 5000}) {
    return _ScheduleState(
      currentPage: currentPage,
    );
  }
}

// ignore: unused_element
const $ScheduleState = _$ScheduleStateTearOff();

mixin _$ScheduleState {
  int get currentPage;

  $ScheduleStateCopyWith<ScheduleState> get copyWith;
}

abstract class $ScheduleStateCopyWith<$Res> {
  factory $ScheduleStateCopyWith(
          ScheduleState value, $Res Function(ScheduleState) then) =
      _$ScheduleStateCopyWithImpl<$Res>;
  $Res call({int currentPage});
}

class _$ScheduleStateCopyWithImpl<$Res>
    implements $ScheduleStateCopyWith<$Res> {
  _$ScheduleStateCopyWithImpl(this._value, this._then);

  final ScheduleState _value;
  // ignore: unused_field
  final $Res Function(ScheduleState) _then;

  @override
  $Res call({
    Object currentPage = freezed,
  }) {
    return _then(_value.copyWith(
      currentPage:
          currentPage == freezed ? _value.currentPage : currentPage as int,
    ));
  }
}

abstract class _$ScheduleStateCopyWith<$Res>
    implements $ScheduleStateCopyWith<$Res> {
  factory _$ScheduleStateCopyWith(
          _ScheduleState value, $Res Function(_ScheduleState) then) =
      __$ScheduleStateCopyWithImpl<$Res>;
  @override
  $Res call({int currentPage});
}

class __$ScheduleStateCopyWithImpl<$Res>
    extends _$ScheduleStateCopyWithImpl<$Res>
    implements _$ScheduleStateCopyWith<$Res> {
  __$ScheduleStateCopyWithImpl(
      _ScheduleState _value, $Res Function(_ScheduleState) _then)
      : super(_value, (v) => _then(v as _ScheduleState));

  @override
  _ScheduleState get _value => super._value as _ScheduleState;

  @override
  $Res call({
    Object currentPage = freezed,
  }) {
    return _then(_ScheduleState(
      currentPage:
          currentPage == freezed ? _value.currentPage : currentPage as int,
    ));
  }
}

class _$_ScheduleState extends _ScheduleState with DiagnosticableTreeMixin {
  const _$_ScheduleState({this.currentPage = 5000})
      : assert(currentPage != null),
        super._();

  @JsonKey(defaultValue: 5000)
  @override
  final int currentPage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ScheduleState(currentPage: $currentPage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ScheduleState'))
      ..add(DiagnosticsProperty('currentPage', currentPage));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _ScheduleState &&
            (identical(other.currentPage, currentPage) ||
                const DeepCollectionEquality()
                    .equals(other.currentPage, currentPage)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(currentPage);

  @override
  _$ScheduleStateCopyWith<_ScheduleState> get copyWith =>
      __$ScheduleStateCopyWithImpl<_ScheduleState>(this, _$identity);
}

abstract class _ScheduleState extends ScheduleState {
  const _ScheduleState._() : super._();
  const factory _ScheduleState({int currentPage}) = _$_ScheduleState;

  @override
  int get currentPage;
  @override
  _$ScheduleStateCopyWith<_ScheduleState> get copyWith;
}
