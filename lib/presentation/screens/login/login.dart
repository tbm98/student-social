import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/dialog_support.dart';
import '../../../models/entities/semester.dart';
import 'login_state_notifier.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with DialogSupport {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FocusNode textSecondFocusNode = FocusNode();
  bool listened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!listened) {
      loginStateNotifier.read(context).getActionStream().listen((value) async {
        if (value['type'] == LoginAction.pop) {
          pop(context);
        } else if (value['type'] == LoginAction.loading) {
          loading(context, value['data']);
        } else if (value['type'] == LoginAction.alert_with_message) {
          showAlertMessage(context, value['data']);
        } else if (value['type'] == LoginAction.alert_chon_kyhoc) {
          _showAlertChonKyHoc(value['data']);
        } else if (value['type'] == LoginAction.save_success) {
          showSuccess(context, 'Đăng nhập hoàn tất');
        }
      });
      listened = true;
    }
  }

  Widget get logo => const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 80,
        backgroundImage: AssetImage('image/Logo.png'),
      );

  Widget email() => TextField(
        controller: emailController,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        onSubmitted: (String value) {
          FocusScope.of(context).requestFocus(textSecondFocusNode);
        },
        decoration: InputDecoration(
          hintText: 'Mã sinh viên',
          labelText: 'Mã sinh viên',
          prefixIcon: const Icon(Icons.account_circle),
          suffixIcon: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                FocusScope.of(context).requestFocus(textSecondFocusNode);
              }),
          contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  Widget password() {
    return TextField(
      focusNode: textSecondFocusNode,
      controller: passwordController,
      obscureText: true,
      onSubmitted: (String value) {
        loginStateNotifier
            .read(context)
            .submit(emailController.text, passwordController.text);
      },
      decoration: InputDecoration(
        hintText: 'Mật khẩu',
        labelText: 'Mật khẩu',
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              loginStateNotifier
                  .read(context)
                  .submit(emailController.text, passwordController.text);
            }),
        contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget loginButton() {
    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.all(0),
      child: RaisedButton(
        onPressed: () {
          loginStateNotifier
              .read(context)
              .submit(emailController.text, passwordController.text);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: Colors.green,
        child: const Text('ĐĂNG NHẬP', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logo,
                const Padding(padding: EdgeInsets.only(top: 16)),
                const Text('Student Social',
                    style: TextStyle(color: Colors.black, fontSize: 40)),
                const Padding(padding: EdgeInsets.only(top: 48)),
                email(),
                const Padding(padding: EdgeInsets.only(top: 12)),
                password(),
                const Padding(padding: EdgeInsets.only(top: 24)),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemKyHoc(BuildContext context, Semester data) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Kỳ ${data.TenKy.split('_')[0]} năm ${data.TenKy.split('_')[1]}-${data.TenKy.split('_')[2]}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green),
              ),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                loginStateNotifier.read(context).semesterClicked(data.MaKy);
              },
              contentPadding: const EdgeInsets.all(0),
            ),
            const Divider(
              height: 1,
            )
          ],
        ));
  }

  void _showAlertChonKyHoc(SemesterResult data) {
    final AlertDialog alertDialog = AlertDialog(
      title: const Text('Chọn kỳ học'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.message.length,
                itemBuilder: (BuildContext buildContext, int index) =>
                    _itemKyHoc(context, data.message[index]),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
