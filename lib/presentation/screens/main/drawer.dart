import 'package:flutter/material.dart';
import 'package:lazy_code/lazy_code.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/entities/profile.dart';
import '../../../models/local/database/database.dart';
import '../extracurricular/extracurricular.dart';
import '../login/login.dart';
import '../login/login_state_notifier.dart';
import '../mark/mark.dart';
import '../mark/mark_notifier.dart';
import '../qr/qrcode_view.dart';
import '../settings.dart';
import '../time_table.dart';
import 'main_state_notifier.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Widget _loginTile() {
    return ListTile(
      title: const Text('Đăng nhập bằng tài khoản sinh viên'),
      leading: const Icon(
        Icons.account_circle,
        size: 30,
        color: Colors.green,
      ),
      onTap: () async {
        context.pop();
        await context.push((BuildContext context) => LoginScreen());
        mainStateNotifier.read(context).loadCurrentMSV();
      },
    );
  }

  Widget _timeTableTile() {
    return ListTile(
      title: const Text('Thời gian ra vào lớp'),
      leading: const Icon(
        Icons.access_time,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        context
          ..pop()
          ..push((_) => TimeTable(msv: mainStateNotifier.read(context).msv));
      },
    );
  }

  Widget _markTile() {
    return ListTile(
      title: const Text('Tra cứu điểm'),
      leading: const Icon(
        Icons.print,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MarkScreen(),
        ));
      },
    );
  }

  Widget _extracurricularTile() {
    return ListTile(
      title: const Text('Tra cứu điểm ngoại khóa'),
      leading: const Icon(
        Icons.score,
        size: 30,
        color: Colors.pink,
      ),
      onTap: () {
        context
          ..pop()
          ..push(
            (_) => ExtracurricularScreen(
              msv: mainStateNotifier.read(context).msv,
            ),
          );
      },
    );
  }

  // ignore: non_constant_identifier_names
  Widget _QRCodeTile() {
    return ListTile(
      title: const Text('Tạo QR CODE'),
      leading: const Icon(
        Icons.blur_on,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => QRCodeScreen(
                data: mainStateNotifier.read(context).msv,
              ),
            ));
      },
    );
  }

  Widget _supportTile() {
    return ListTile(
      title: const Text('Phản ánh lỗi, góp ý'),
      leading: const Icon(
        Icons.error,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        context.pop();
        mainStateNotifier.read(context).launchURL();
      },
    );
  }

  Widget _settingTile() {
    return ListTile(
      title: const Text('Cài đặt ứng dụng'),
      leading: const Icon(
        Icons.settings,
        size: 30,
        color: Colors.green,
      ),
      onTap: () {
        context
          ..pop()
          ..push(((_) => SettingScren()));
      },
    );
  }

  Widget _logoutTile() {
    return ListTile(
      title: const Text('Đăng xuất'),
      leading: const Icon(
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

  Future<void> _confirmLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bạn có muốn đăng xuất không?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Huỷ',
                style: TextStyle(color: Colors.red),
              ),
            ),
            FlatButton(
              onPressed: () {
                mainStateNotifier.read(context).logOut();
                Navigator.of(context).pop();
              },
              child: const Text('Đồng ý'),
            )
          ],
        );
      },
    );
  }

  Widget _drawerHeader() {
    return DrawerHeader(
      padding: const EdgeInsets.only(left: 16),
      decoration: const BoxDecoration(color: Colors.green),
      child: UserAccountsDrawerHeader(
          currentAccountPicture: _getAccountPicture(),
          otherAccountsPictures: <Widget>[
            IconButton(
              icon: const Icon(
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
            content: Consumer((context, read) {
              final mainState = read(mainStateNotifier);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.yellow,
                      child:
                          Text(mainState.getName.substring(0, 1).toUpperCase()),
                    ),
                    title: Text(
                      mainState.getName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(mainState.getClass),
                  ),
                  const Divider(),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: ListView.builder(
                        itemCount: mainState.allProfile.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _layoutItemAccount(index);
                        }),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () async {
                      context..pop()..pop();
                      await context.push((_) => LoginScreen());
                      mainStateNotifier.read(context).loadCurrentMSV();
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 24, top: 4, bottom: 4),
                      child: Row(
                        children: const <Widget>[
                          Icon(
                            Icons.person_add,
                            color: Colors.black54,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            // ignore: prefer_const_literals_to_create_immutables
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
              );
            }),
          );
        });
  }

  Widget _layoutItemAccount(int index) {
    final Profile profile = mainStateNotifier.read(context).allProfile[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: mainStateNotifier.read(context).getRandomColor(),
        child: Text(profile?.HoTen?.substring(0, 1)?.toUpperCase()),
      ),
      title: Text(
        profile.HoTen ?? 'Họ Tên',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(profile.Lop ?? 'Lớp trống',
          style: const TextStyle(fontSize: 11)),
      onTap: () async {
        mainStateNotifier.read(context).switchToProfile(profile);
        context..pop()..pop();
      },
    );
  }

  Widget _nameOfUser() {
    if (mainStateNotifier.read(context).msv == 'DTC165D4801030254') {
      return const Text(
        'TUyenOC',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return Text(
        mainStateNotifier.read(context).getName,
        style: const TextStyle(color: Colors.white),
      );
    }
  }

  Widget _classOfUser() {
    if (mainStateNotifier.read(context).msv == 'DTC165D4801030254') {
      return const Text(
        'Tài khoản Premium',
        style: TextStyle(color: Colors.white),
      );
    } else {
      if (mainStateNotifier.read(context).getClass.isNotEmpty) {
        return Text(
          mainStateNotifier.read(context).getClass,
          style: const TextStyle(color: Colors.white),
        );
      } else {
        return const SizedBox();
      }
    }
  }

  Widget _getAccountPicture() {
    if (mainStateNotifier.read(context).isGuest) {
      // logo for guest
      return Container(
        width: 80,
        height: 80,
        child: const CircleAvatar(
          backgroundColor: Colors.green,
          backgroundImage: AssetImage('image/Logo.png'),
        ),
      );
    }

    return Container(
      width: 80,
      height: 80,
      child: CircleAvatar(
        backgroundColor: Colors.yellow,
        child: Text(
          mainStateNotifier.read(context).getAvatarName,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget listItemDrawer() {
    return Consumer((context, read) {
      if (read(mainStateNotifier).isGuest) {
        //những menu này dành cho người chưa đăng nhập
        return ListView(padding: EdgeInsets.zero, children: [
          _drawerHeader(),
          _loginTile(),
          _timeTableTile(),
          _QRCodeTile(),
          _supportTile(),
          const Divider(),
          _settingTile()
        ]);
      } else {
        //menu dành cho người dùng đã đăng nhập
        return ListView(padding: EdgeInsets.zero, children: [
          _drawerHeader(),
          _timeTableTile(),
          _markTile(),
          _extracurricularTile(), //Điểm ngoại khóa
          _QRCodeTile(),
          _supportTile(),
          _logoutTile(),
          const Divider(),
          _settingTile()
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: listItemDrawer(),
    );
  }
}
