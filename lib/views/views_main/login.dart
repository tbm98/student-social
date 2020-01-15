import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studentsocial/support/dialog_support.dart';
import 'package:studentsocial/viewmodels/login_viewmodel.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with DialogSupport{
  LoginViewModel _loginViewModel;
  FocusNode textSecondFocusNode = FocusNode();
  bool listened = false;

  _initViewModel() {
    _loginViewModel = Provider.of<LoginViewModel>(context);
    if (!listened) {
      _loginViewModel.getActionStream().listen((value) async{
        if (value['type'] == LoginAction.pop) {
          pop(context);
        } else if (value['type'] == LoginAction.loading) {
          loading(context,value['data']);
        } else if (value['type'] == LoginAction.alert_with_message) {
          showAlertMessage(context,value['data']);
        } else if (value['type'] == LoginAction.alert_chon_kyhoc) {
          _showAlertChonKyHoc(value['data']);
        } else if (value['type'] == LoginAction.save_success) {
          await showSuccess(context,'Đăng nhập hoàn tất');
          pop(context);
        }
      });
      listened = true;
    }
  }

  Widget logo = CircleAvatar(
    backgroundColor: Colors.transparent,
    radius: 80,
    backgroundImage: AssetImage('image/Logo.png'),
  );

  Widget email() => TextField(
        controller: _loginViewModel.getControllerMSV,
        autofocus: true,
        textCapitalization: TextCapitalization.characters,
        onSubmitted: (value) {
          FocusScope.of(context).requestFocus(textSecondFocusNode);
        },
        decoration: InputDecoration(
          hintText: 'Mã sinh viên',
          labelText: 'Mã sinh viên',
          prefixIcon: Icon(Icons.account_circle),
          suffixIcon: IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                FocusScope.of(context).requestFocus(textSecondFocusNode);
              }),
          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      );

  Widget password() => TextField(
        focusNode: textSecondFocusNode,
        controller: _loginViewModel.getControllerPassword,
        obscureText: true,
        onSubmitted: (value) {
          _loginViewModel.submit();
        },
        decoration: InputDecoration(
          hintText: 'Mật khẩu',
          labelText: 'Mật khẩu',
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                _loginViewModel.submit();
              }),
          contentPadding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      );

  Widget loginButton() => Container(
        width: double.infinity,
        height: 44,
        padding: const EdgeInsets.all(0),
        child: RaisedButton(
          child: Text('ĐĂNG NHẬP', style: TextStyle(color: Colors.white)),
          onPressed: () {
            _loginViewModel.submit();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.green,
        ),
      );

  @override
  Widget build(BuildContext context) {
    _initViewModel();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                logo,
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                ),
                Text(
                  'Student Social',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48),
                ),
                email(),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                ),
                password(),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                ),
                loginButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemKyHoc(BuildContext context, data, kyTruoc) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Kỳ ${data["TenKy"].split('_')[0]} năm ${data["TenKy"].split('_')[1]}-${data["TenKy"].split('_')[2]}',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                _loginViewModel.semesterClicked(data['MaKy'], kyTruoc['MaKy']);
              },
              contentPadding: const EdgeInsets.all(0),
            ),
            Divider(
              height: 1,
            )
          ],
        ));
  }

  void _showAlertChonKyHoc(data) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Chọn kỳ học'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext buildContext, int index) =>
                    _itemKyHoc(context, data[index],
                        index == data.length - 1 ? null : data[index + 1]),
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
