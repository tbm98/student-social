import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:provider/provider.dart';

import '../../../helpers/dialog_support.dart';
import '../../../models/entities/calendar_day.dart';
import '../../../viewmodels/calendar_viewmodel.dart';
import '../../../viewmodels/schedule_viewmodel.dart';
import '../../common_widgets/add_note.dart';
import '../../common_widgets/calendar_page.dart';
import '../../common_widgets/list_schedule.dart';
import '../../common_widgets/update_lich.dart';
import 'button_current_day.dart';
import 'drawer.dart';
import 'main_notifier.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, DialogSupport {
  MainNotifier _mainNotifier;
  final CalendarViewModel _calendarViewModel = CalendarViewModel();
  final ScheduleViewModel _scheduleViewModel = ScheduleViewModel();
  Animation<double> animation;
  AnimationController animationController;
  bool listened = false;

  void _initViewModel() {
    _mainNotifier = context.read<MainNotifier>();
    _mainNotifier.initSize(MediaQuery.of(context).size);
    if (!listened) {
      _mainNotifier.getStreamAction.listen((data) {
        if (data['type'] == MainAction.alert_with_message) {
          showAlertMessage(context, data['data']);
        } else if (data['type'] == MainAction.alert_update_schedule) {
          _showDialogUpdateLich();
        } else if (data['type'] == MainAction.pop) {
          context.pop();
        } else if (data['type'] == MainAction.forward) {
          animationController.forward();
        } else if (data['type'] == MainAction.reverse) {
          animationController.reverse();
        }
      });
      listened = true;
    }
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
    );
    animationController.reverse();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initViewModel();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Social'),
        actions: <Widget>[
          ButtonCurrentDay(
            animation: animation,
            onTap: () {
              _calendarViewModel.onClickedCurrentDay(CalendarDay.now());
              _scheduleViewModel.onClickedCurrentDay(CalendarDay.now());
            },
            currentDay: _calendarViewModel.currentDay.day.toString(),
          ),
          _layoutRefesh,
        ],
      ),
      body: _mainLayout(),
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogAddGhiChu();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget get _layoutRefesh {
    if (_mainNotifier.getMSV != null && _mainNotifier.getMSV != 'guest') {
      return IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _mainNotifier.updateSchedule);
    } else {
      return const SizedBox();
    }
  }

  Future<void> _showDialogAddGhiChu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddNote(
          date: _mainNotifier.getClickedDay,
          context: this.context,
        ); //magic ^_^
      },
    );
  }

  /*
   * show dialog khi bao vao update lich
   */

  Future<void> _showDialogUpdateLich() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return UpdateLich(
          mcontext: this.context,
        ); //magic ^_^
      },
    );
  }

  /*
   * show dialog khi bam vao them ghi chu
   */

  Future<void> showDialogAddGhiChu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddNote(
//          date: _mainViewModel.getDate,
            ); //magic ^_^
      },
    );
  }

  Widget _mainLayout() {
    return Container(
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: calendarView(),
          ),
          listSchedule()
        ],
      ),
    );
  }

  Widget calendarView() {
    return Container(
        width: double.infinity,
        height: _mainNotifier.getTableHeight,
        child: MultiProvider(
          providers: [
//            ChangeNotifierProvider<MainViewModel>.value(value: _mainViewModel),
            ChangeNotifierProvider<ScheduleViewModel>.value(
                value: _scheduleViewModel),
            ChangeNotifierProvider<CalendarViewModel>.value(
                value: _calendarViewModel)
          ],
          child: Calendar(),
        ));
  }

  Widget listSchedule() {
    return Expanded(
        child: MultiProvider(
      providers: [
//        ChangeNotifierProvider<MainViewModel>.value(value: _mainViewModel),
        ChangeNotifierProvider<ScheduleViewModel>.value(
            value: _scheduleViewModel),
        ChangeNotifierProvider<CalendarViewModel>.value(
            value: _calendarViewModel)
      ],
      child: ListSchedule(),
    ));
  }
}
