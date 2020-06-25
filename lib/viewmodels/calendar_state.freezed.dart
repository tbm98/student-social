// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'calendar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$CalendarStateTearOff {
  const _$CalendarStateTearOff();

  _CalendarState call(
      {Map<int, CalendarModel> calendarModels = const <int, CalendarModel>{},
      int currentPage = 12,
      CalendarDay currentDay,
      CalendarDay clickDay,
      int indexPageByClickDay = 12}) {
    return _CalendarState(
      calendarModels: calendarModels,
      currentPage: currentPage,
      currentDay: currentDay,
      clickDay: clickDay,
      indexPageByClickDay: indexPageByClickDay,
    );
  }
}

// ignore: unused_element
const $CalendarState = _$CalendarStateTearOff();

mixin _$CalendarState {
  Map<int, CalendarModel> get calendarModels;
  int get currentPage;
  CalendarDay get currentDay;
  CalendarDay get clickDay;
  int get indexPageByClickDay;

  $CalendarStateCopyWith<CalendarState> get copyWith;
}

abstract class $CalendarStateCopyWith<$Res> {
  factory $CalendarStateCopyWith(
          CalendarState value, $Res Function(CalendarState) then) =
      _$CalendarStateCopyWithImpl<$Res>;
  $Res call(
      {Map<int, CalendarModel> calendarModels,
      int currentPage,
      CalendarDay currentDay,
      CalendarDay clickDay,
      int indexPageByClickDay});
}

class _$CalendarStateCopyWithImpl<$Res>
    implements $CalendarStateCopyWith<$Res> {
  _$CalendarStateCopyWithImpl(this._value, this._then);

  final CalendarState _value;
  // ignore: unused_field
  final $Res Function(CalendarState) _then;

  @override
  $Res call({
    Object calendarModels = freezed,
    Object currentPage = freezed,
    Object currentDay = freezed,
    Object clickDay = freezed,
    Object indexPageByClickDay = freezed,
  }) {
    return _then(_value.copyWith(
      calendarModels: calendarModels == freezed
          ? _value.calendarModels
          : calendarModels as Map<int, CalendarModel>,
      currentPage:
          currentPage == freezed ? _value.currentPage : currentPage as int,
      currentDay:
          currentDay == freezed ? _value.currentDay : currentDay as CalendarDay,
      clickDay: clickDay == freezed ? _value.clickDay : clickDay as CalendarDay,
      indexPageByClickDay: indexPageByClickDay == freezed
          ? _value.indexPageByClickDay
          : indexPageByClickDay as int,
    ));
  }
}

abstract class _$CalendarStateCopyWith<$Res>
    implements $CalendarStateCopyWith<$Res> {
  factory _$CalendarStateCopyWith(
          _CalendarState value, $Res Function(_CalendarState) then) =
      __$CalendarStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {Map<int, CalendarModel> calendarModels,
      int currentPage,
      CalendarDay currentDay,
      CalendarDay clickDay,
      int indexPageByClickDay});
}

class __$CalendarStateCopyWithImpl<$Res>
    extends _$CalendarStateCopyWithImpl<$Res>
    implements _$CalendarStateCopyWith<$Res> {
  __$CalendarStateCopyWithImpl(
      _CalendarState _value, $Res Function(_CalendarState) _then)
      : super(_value, (v) => _then(v as _CalendarState));

  @override
  _CalendarState get _value => super._value as _CalendarState;

  @override
  $Res call({
    Object calendarModels = freezed,
    Object currentPage = freezed,
    Object currentDay = freezed,
    Object clickDay = freezed,
    Object indexPageByClickDay = freezed,
  }) {
    return _then(_CalendarState(
      calendarModels: calendarModels == freezed
          ? _value.calendarModels
          : calendarModels as Map<int, CalendarModel>,
      currentPage:
          currentPage == freezed ? _value.currentPage : currentPage as int,
      currentDay:
          currentDay == freezed ? _value.currentDay : currentDay as CalendarDay,
      clickDay: clickDay == freezed ? _value.clickDay : clickDay as CalendarDay,
      indexPageByClickDay: indexPageByClickDay == freezed
          ? _value.indexPageByClickDay
          : indexPageByClickDay as int,
    ));
  }
}

class _$_CalendarState extends _CalendarState with DiagnosticableTreeMixin {
  const _$_CalendarState(
      {this.calendarModels = const <int, CalendarModel>{},
      this.currentPage = 12,
      this.currentDay,
      this.clickDay,
      this.indexPageByClickDay = 12})
      : assert(calendarModels != null),
        assert(currentPage != null),
        assert(indexPageByClickDay != null),
        super._();

  @JsonKey(defaultValue: const <int, CalendarModel>{})
  @override
  final Map<int, CalendarModel> calendarModels;
  @JsonKey(defaultValue: 12)
  @override
  final int currentPage;
  @override
  final CalendarDay currentDay;
  @override
  final CalendarDay clickDay;
  @JsonKey(defaultValue: 12)
  @override
  final int indexPageByClickDay;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'CalendarState(calendarModels: $calendarModels, currentPage: $currentPage, currentDay: $currentDay, clickDay: $clickDay, indexPageByClickDay: $indexPageByClickDay)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'CalendarState'))
      ..add(DiagnosticsProperty('calendarModels', calendarModels))
      ..add(DiagnosticsProperty('currentPage', currentPage))
      ..add(DiagnosticsProperty('currentDay', currentDay))
      ..add(DiagnosticsProperty('clickDay', clickDay))
      ..add(DiagnosticsProperty('indexPageByClickDay', indexPageByClickDay));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CalendarState &&
            (identical(other.calendarModels, calendarModels) ||
                const DeepCollectionEquality()
                    .equals(other.calendarModels, calendarModels)) &&
            (identical(other.currentPage, currentPage) ||
                const DeepCollectionEquality()
                    .equals(other.currentPage, currentPage)) &&
            (identical(other.currentDay, currentDay) ||
                const DeepCollectionEquality()
                    .equals(other.currentDay, currentDay)) &&
            (identical(other.clickDay, clickDay) ||
                const DeepCollectionEquality()
                    .equals(other.clickDay, clickDay)) &&
            (identical(other.indexPageByClickDay, indexPageByClickDay) ||
                const DeepCollectionEquality()
                    .equals(other.indexPageByClickDay, indexPageByClickDay)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(calendarModels) ^
      const DeepCollectionEquality().hash(currentPage) ^
      const DeepCollectionEquality().hash(currentDay) ^
      const DeepCollectionEquality().hash(clickDay) ^
      const DeepCollectionEquality().hash(indexPageByClickDay);

  @override
  _$CalendarStateCopyWith<_CalendarState> get copyWith =>
      __$CalendarStateCopyWithImpl<_CalendarState>(this, _$identity);
}

abstract class _CalendarState extends CalendarState {
  const _CalendarState._() : super._();
  const factory _CalendarState(
      {Map<int, CalendarModel> calendarModels,
      int currentPage,
      CalendarDay currentDay,
      CalendarDay clickDay,
      int indexPageByClickDay}) = _$_CalendarState;

  @override
  Map<int, CalendarModel> get calendarModels;
  @override
  int get currentPage;
  @override
  CalendarDay get currentDay;
  @override
  CalendarDay get clickDay;
  @override
  int get indexPageByClickDay;
  @override
  _$CalendarStateCopyWith<_CalendarState> get copyWith;
}
