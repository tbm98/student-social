import 'dart:async';
import 'package:flutter/material.dart';
import 'package:studentsocial/models/object/calendar_day.dart';
import 'package:studentsocial/models/object/profile.dart';
import 'package:studentsocial/support/dialog_support.dart';
import 'package:studentsocial/viewmodels/calendar_viewmodel.dart';
import 'package:studentsocial/viewmodels/schedule_viewmodel.dart';
import 'package:studentsocial/viewmodels/login_viewmodel.dart';
import 'package:studentsocial/viewmodels/main_viewmodel.dart';
import 'package:studentsocial/viewmodels/mark_viewmodel.dart';
import 'package:studentsocial/views/views_component/calendar_page.dart';
import 'package:studentsocial/views/views_component/add_note.dart';
import 'package:studentsocial/views/views_component/list_schedule.dart';
import 'package:studentsocial/views/views_component/update_lich.dart';
import 'diem_ngoai_khoa.dart';
import 'qrcode_view.dart';
import 'settings.dart';
import 'time_table.dart';
import 'login.dart';
import 'mark_view.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  State createState() => new MainPageState();
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, DialogSupport {
  MainViewModel _mainViewModel;
  CalendarViewModel _calendarViewModel = CalendarViewModel();
  ScheduleViewModel _scheduleViewModel = ScheduleViewModel();
  Animation<double> animation;
  AnimationController animationController;
  bool listened = false;


  _initViewModel() {
    _mainViewModel = Provider.of<MainViewModel>(context);
    _mainViewModel.initSize(MediaQuery.of(context).size);
    if (!listened) {
      _mainViewModel.getStreamAction.listen((data) {
        if (data['type'] == MainAction.alert_with_message) {
          showAlertMessage(context, data['data']);
        } else if (data['type'] == MainAction.alert_update_schedule) {
          _showDialogUpdateLich();
        } else if (data['type'] == MainAction.pop) {
          Navigator.of(context).pop();
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
      duration: Duration(milliseconds: 1000),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticOut,
    );
    animationController.reverse();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initViewModel();
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Social'),
        actions: <Widget>[
          AnimatedBuilder(
            animation: animation,
            child: ScaleTransition(
              scale: animation,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FloatingActionButton(
                  heroTag: 'button_current_day',
                  onPressed: () {
                    _calendarViewModel.onClickedCurrentDay(CalendarDay.now());
                    _scheduleViewModel.onClickedCurrentDay(CalendarDay.now());
                  },
                  mini: true,
                  child: Text(
                    _calendarViewModel.currentDay.day.toString(),
                    style: TextStyle(color: Colors.green),
                  ),
                  backgroundColor: Colors.yellow,
                ),
              ),
            ),
            builder: (BuildContext context, Widget child) {
              return child;
            },
          ),
          _layoutRefesh(),
        ],
      ),
      body: _mainLayout(),
      drawer:
          SizedBox(width: _mainViewModel.getWidthDrawer, child: drawerWidget()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialogAddGhiChu();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _layoutRefesh() {
    if (_mainViewModel.getMSV != null && _mainViewModel.getMSV != 'guest') {
      return IconButton(
          icon: Icon(Icons.refresh), onPressed: _mainViewModel.updateSchedule);
    } else {
      return Container();
    }
  }

  Future<void> _showDialogAddGhiChu() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AddNote(
          date: _mainViewModel.getClickedDay,
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
        height: _mainViewModel.getTableHeight,
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

  Widget _nameOfUser() {
    if(_mainViewModel.getMSV == 'DTC165D4801030254'){
      return Text("TUyenOC",
        style: TextStyle(color: Colors.white),
      );
    }else{
      return Text(
        _mainViewModel.getName(),
        style: TextStyle(color: Colors.white),
      );
    }



  }

  Widget _classOfUser() {
    if(_mainViewModel.getMSV == 'DTC165D4801030254'){
      return Text(
        "Tài khoản Premium",
        style: TextStyle(color: Colors.white),
      );
    }else{
      return Text(
        _mainViewModel.getClass,
        style: TextStyle(color: Colors.white),
      );
    }
  }

  Drawer drawerWidget() {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: listItemDrawer()),
    );
  }

  DrawerHeader _layoutDrawerHeader() {
    return DrawerHeader(
      padding: const EdgeInsets.only(left: 16),
      child: UserAccountsDrawerHeader(
          currentAccountPicture: _getAccountPicture(),
          otherAccountsPictures: <Widget>[
            IconButton(
              icon: Icon(
                Icons.supervised_user_circle,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                _showAccountSetting();
              },
            ),
          ],
          accountName: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _nameOfUser(),
          ),
          accountEmail: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: _classOfUser(),
          )),
      decoration: BoxDecoration(color: Colors.green),
    );
  }

  void _showAccountSetting() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(6),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.yellow,
                    child: Text(
                        _mainViewModel.getName().substring(0, 1).toUpperCase()),
                  ),
                  title: Text(
                    _mainViewModel.getName(),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(_mainViewModel.getClass),
                ),
                Divider(),
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ListView.builder(
                      itemCount: _mainViewModel.getAllProfile.length,
                      itemBuilder: (context, index) {
                        return _layoutItemAccount(index);
                      }),
                ),
                Divider(),
                GestureDetector(
                  onTap: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ChangeNotifierProvider<LoginViewModel>(
                              create: (_) => LoginViewModel(),
                              child: LoginPage(),
                            )));
                    _mainViewModel.loadCurrentMSV();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, top: 4, bottom: 4),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person_add,
                          color: Colors.black54,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            'Thêm một tài khoản khác',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _layoutItemAccount(int index) {
    Profile profile = _mainViewModel.getAllProfile[index];
    return ListTile(
      leading: Container(
        child: CircleAvatar(
          backgroundColor: _mainViewModel.getRandomColor(),
          child: Text(profile.HoTen.substring(0, 1).toUpperCase()),
        ),
      ),
      title: Text(
        profile.HoTen,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(profile.Lop, style: TextStyle(fontSize: 11)),
      onTap: () async {
        _mainViewModel.switchToProfile(profile);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }

  Widget _getAccountPicture() {
    if (_mainViewModel.getName == null || _mainViewModel.getName == 'Họ Tên') {
      return Container(
        width: 80,
        height: 80,
        child: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: AssetImage('image/Logo.png'),
        ),
      );
    }
    if(_mainViewModel.getMSV == 'DTC165D4801030254'){
      return Container(
        width: 80,
        height: 80,
        child: CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: AssetImage('image/tuyen.png'),
        ),
      );
    }else {
      return Container(
        width: 80,
        height: 80,
        child: CircleAvatar(
          backgroundColor: Colors.yellow,
          child: Text(_mainViewModel.getName().split(" ")[_mainViewModel.getName().split(" ").length-1][0], style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
        ),
      );
    }
  }

  Future<void> _confirmLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bạn có muốn đăng xuất không?'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Huỷ',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Đồng ý'),
              onPressed: () {
                _mainViewModel.logOut();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  List<Widget> listItemDrawer() {
    if (_mainViewModel.getMSV == null || _mainViewModel.getMSV == 'guest') {
      //những menu này dành cho người chưa đăng nhập
      return [
        Container(child: _layoutDrawerHeader()),
        _layoutLogin(),
        _layoutTimeTable(),
        _layoutQRCode(),
        _layoutSupport(),
        Divider(),
        _layoutSetting()
      ];
    } else {
      //menu dành cho người dùng đã đăng nhập
      return [
        Container(child: _layoutDrawerHeader()),
        _layoutTimeTable(),
        _layoutMarkView(),
        _layoutDNK(), //Điểm ngoại khóa
        _layoutQRCode(),
        _layoutSupport(),
        _layoutLogout(),
        Divider(),
        _layoutSetting()
      ];
    }
  }

  Widget _layoutLogin() {
    return ListTile(
      title: Text('Đăng nhập bằng tài khoản'),
      leading: Icon(
        Icons.access_time,
        size: 30,
        color: Colors.green,
      ),
      onTap: () async {
        Navigator.of(context).pop();
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<LoginViewModel>(
                  create: (_) => LoginViewModel(),
                  child: LoginPage(),
                )));
        _mainViewModel.loadCurrentMSV();
      },
    );
  }

  Widget _layoutTimeTable() {
    return ListTile(
      title: Text('Thời gian ra vào lớp'),
      leading: Icon(
        Icons.access_time,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => TimeTable(msv: _mainViewModel.getMSV)));
      },
    );
  }

  Widget _layoutMarkView() {
    return ListTile(
      title: Text('Tra cứu điểm'),
      leading: Icon(
        Icons.print,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<MarkViewModel>(
                  create: (_) => MarkViewModel(),
                  child: MarkView(),
                )));
      },
    );
  }

  Widget _layoutDNK() {
    return ListTile(
      title: Text('Tra cứu điểm ngoại khóa'),
      leading: Icon(
        Icons.score,
        size: 30,
        color: Colors.pink,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => DiemNgoaiKhoa(
            msv: _mainViewModel.getMSV,
          ),
        ));
      },
    );
  }

  Widget _layoutQRCode() {
    return ListTile(
      title: Text('Tạo QR CODE'),
      leading: Icon(
        Icons.blur_on,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => QRCodeView(
                data: _mainViewModel.getMSV,
              ),
            ));
      },
    );
  }

  Widget _layoutSupport() {
    return ListTile(
      title: Text('Phản ánh lỗi, góp ý'),
      leading: Icon(
        Icons.contact_phone,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        _mainViewModel.launchURL();
      },
    );
  }

  Widget _layoutSetting() {
    return ListTile(
      title: Text('Cài đặt ứng dụng'),
      leading: Icon(
        Icons.settings,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => Settings()));
      },
    );
  }

  Widget _layoutLogout() {
    return ListTile(
      title: Text('Đăng xuất'),
      leading: Icon(
        Icons.exit_to_app,
        size: 30,
        color: Colors.red,
      ),
      onTap: () {
        Navigator.of(context).pop();
        _confirmLogout();
      },
    );
  }
}
