import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/dialog_support.dart';
import '../../../models/entities/calendar_day.dart';
import '../../../viewmodels/calendar_state_notifier.dart';
import '../../../viewmodels/schedule_state_notifier.dart';
import '../../common_widgets/add_note.dart';
import '../../common_widgets/calendar_page.dart';
import '../../common_widgets/list_schedule.dart';
import '../../common_widgets/update_lich.dart';
import 'button_current_day.dart';
import 'drawer.dart';
import 'main_state_notifier.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => new MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin, DialogSupport {
  Animation<double> animation;
  AnimationController animationController;
  bool listened = false;

  void _initViewModel() {
    mainStateNotifier.read(context).initSize(MediaQuery.of(context).size);
    if (!listened) {
      mainStateNotifier.read(context).getStreamAction.listen((data) {
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
          Consumer((context, read) {
            return ButtonCurrentDay(
              animation: animation,
              onTap: () {
                calendarStateNotifier
                    .read(context)
                    .onClickedCurrentDay(CalendarDay.now());
                scheduleStateNotifier
                    .read(context)
                    .onClickedCurrentDay(CalendarDay.now());
              },
              currentDay: read(calendarStateNotifier)
                  .state
                  .getCurrentDay
                  .day
                  .toString(),
            );
          }),
          _layoutRefesh,
        ],
      ),
      body: _mainLayout(),
      drawer: DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogAddGhiChu(mainStateNotifier.read(context).clickDate);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget get _layoutRefesh {
    return Consumer((context, read) {
      final mainState = read(mainStateNotifier);
      if (mainState.msv != null && mainState.msv != 'guest') {
        return IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: mainState.updateSchedule);
      } else {
        return const SizedBox();
      }
    });
  }

  Future<void> _showDialogAddGhiChu(DateTime clickDate) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (_) {
        return AddNote(
          date: clickDate,
        );
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
    return Consumer((context, read) {
      return Container(
        width: double.infinity,
        height: read(mainStateNotifier).tableHeight,
        child: Calendar(),
      );
    });
  }

  Widget listSchedule() {
    return Expanded(
      child: ListSchedule(),
    );
  }
}
