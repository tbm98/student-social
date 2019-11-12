import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:studentsocial/support/dialog_support.dart';
import 'package:studentsocial/support/platform_channel.dart';
import 'package:studentsocial/viewmodels/main_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:studentsocial/support/networking.dart';

class UpdateLich extends StatefulWidget {
  final BuildContext mcontext;

  UpdateLich({this.mcontext});

  @override
  _UpdateLichState createState() => _UpdateLichState();
}

class _UpdateLichState extends State<UpdateLich> with DialogSupport{
  MainViewModel _mainViewModel;
  NetWorking _netWorking;
  String lichHoc,lichThi,lichThiLai;

  Map<String, String> subjectsName = Map<String, String>();
  Map<String, String> subjectsSoTinChi = Map<String, String>();

  @override
  void initState() {
    super.initState();
    _mainViewModel = Provider.of<MainViewModel>(widget.mcontext);
    _netWorking = NetWorking();
    _loadSemester();
  }

  void _loadSemester() async {
    String value = await _netWorking.getSemester(_mainViewModel.getToken);
    var jsonData = json.decode(value);
    Navigator.of(context).pop();
    _showChonKiHoc(jsonData);
  }

  void _alertWithMessage(String _msg) {
    AlertDialog dialog = new AlertDialog(
      content: Text(_msg),
      actions: <Widget>[
        FlatButton(
          child: Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  void loadData(String semester, String semester2) async {
    loading(widget.mcontext, 'Đang lấy lịch học');
    lichHoc = await _netWorking.getLichHoc(_mainViewModel.getToken,semester);
    pop(widget.mcontext);
    loading(widget.mcontext, 'Đang lấy lịch thi');
    lichThi = await _netWorking.getLichThi(_mainViewModel.getToken,semester);
    pop(widget.mcontext);
    if (semester2.isNotEmpty) {
      loading(widget.mcontext, 'Đang lấy lịch thi lại');
      lichThiLai = await _netWorking.getLichThi(_mainViewModel.getToken,semester2);
      pop(widget.mcontext);
    }
    _saveInfo();
  }

  void _saveInfo() async {
    //tách và lấy ra tất cả tên và số tín chỉ của từng môn học
    addSubjects(lichHoc);
    addSubjects(lichThi);
    addSubjects(lichThiLai);
    //validate lich hoc
    validateLichHoc();
    //validate lich thi
    validateLichThi();
    //validate lich thi lai
    validateLichThiLai();
    //Xoá lịch cũ và lưu lịch mới :))
    await removeScheduleOld();
    await saveScheduleToDB();
    showSuccess(widget.mcontext,'Cập nhật lịch cá nhân hoàn tất');
    _mainViewModel.loadCurrentMSV();
  }

  Future removeScheduleOld() async {
    var res = await PlatformChannel().deleteScheduleByMSVWithOutNote(_mainViewModel.getMSV);
  }

  Future saveScheduleToDB() async {
    var res = await PlatformChannel().saveScheduleToDB(
        lichHoc, lichThi, lichThiLai, _mainViewModel.getMSV, json.encode(subjectsName));
  }

  void validateLichHoc() {
    lichHoc = lichHoc.substring(lichHoc.indexOf('['));
    lichHoc = lichHoc.substring(0, lichHoc.indexOf(']') + 1);
  }

  void validateLichThi() {
    lichThi = lichThi.substring(lichThi.indexOf('['));
    lichThi = lichThi.substring(0, lichThi.indexOf(']') + 1);
  }

  void validateLichThiLai() {
    lichThiLai = lichThiLai.substring(lichThiLai.indexOf('['));
    lichThiLai = lichThiLai.substring(0, lichThiLai.indexOf(']') + 1);
  }

  void addSubjects(value) {
    var jsonValue = json.decode(value);
    var listSubjects = jsonValue['Subjects'];
    for (var item in listSubjects) {
      addSubjectsName(item['MaMon'],item['TenMon']);
      addSubjectsSoTinChi(item['MaMon'],item['SoTinChi'].toString());
    }
  }

  void addSubjectsName(maMon, tenMon) {
    subjectsName[maMon] = tenMon;
  }

  void addSubjectsSoTinChi(maMon, String soTinChi) {
    subjectsSoTinChi[maMon] = soTinChi;
  }

  Widget _layoutItemSemester(BuildContext context, data, data2) {
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
                if (data2 != null) {
                  //co du lieu data2 => co lich thi lai
                }
                Navigator.of(widget.mcontext).pop();
                loadData(data["MaKy"], data2["MaKy"]);
              },
              contentPadding: const EdgeInsets.all(0),
            ),
            Divider(height: 1,)
          ],
        ));
  }

  void _showChonKiHoc(data) {
    AlertDialog alertDialog = AlertDialog(
      key: Key('dialog_chonky'),
      title: Text('Chọn kỳ học'),
      content: Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext buildContext, int index) => _layoutItemSemester(
                    context,
                    data[index],
                    index < data.length - 1 ? data[index + 1] : null),
                shrinkWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  AlertDialog contentUpdateSchedule() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      contentPadding: const EdgeInsets.all(16),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              width: 30,
              height: 30,
              child: Center(child: CircularProgressIndicator())),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text('Đang lấy danh sách kỳ học'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return contentUpdateSchedule();
  }
}
