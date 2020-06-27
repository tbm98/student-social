import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:provider/provider.dart';
import 'package:studentsocial/models/entities/schedule.dart';

import '../../../helpers/dialog_support.dart';
import '../../common_widgets/add_note.dart';
import '../../common_widgets/calendar.dart';
import '../../common_widgets/update_lich.dart';
import 'drawer.dart';
import 'main_notifier.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with DialogSupport {
  MainNotifier _mainNotifier;
  bool listened = false;

  void _initViewModel() {
    _mainNotifier = context.read<MainNotifier>();
    _mainNotifier.initSize(MediaQuery.of(context).size);
    if (!listened) {
      _mainNotifier.getStreamAction.listen((data) {
        if (data['type'] == MainAction.alert_with_message) {
          showAlertMessage(context, data['data']);
          setState(() {});
        } else if (data['type'] == MainAction.alert_update_schedule) {
          _showDialogUpdateLich();
        } else if (data['type'] == MainAction.pop) {
          context.pop();
        }
      });
      listened = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Social'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                //TODO: add action upload schedule to google calendar
              },
              icon: const Icon(Icons.cloud_upload)),
          _layoutRefesh,
        ],
      ),
      body: Selector<MainNotifier, List<Schedule>>(
        selector: (_, mainNotifier) => mainNotifier.getSchedules,
        builder: (_, schedules, __) {
          if (schedules == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return CalendarWidget(
            schedules: schedules,
          );
        },
      ),
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
    return Selector<MainNotifier, bool>(
      selector: (_, mainNotifier) => mainNotifier.isGuest,
      builder: (_, isGuest, __) {
        if (isGuest) {
          return const SizedBox();
        } else {
          return IconButton(
            icon: const Icon(Icons.refresh),
//            onPressed: _mainNotifier.updateSchedule,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (ct) {
                    return AlertDialog(
                      title: Text(':('),
                      content: Text('Tính năng đang được bảo trì'),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.of(ct).pop();
                          },
                          child: Text('ok'),
                        )
                      ],
                    );
                  });
            },
          );
        }
      },
    );
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
}
