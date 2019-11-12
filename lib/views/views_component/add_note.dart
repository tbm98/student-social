/*
 * Widget Dialog hien thi them ghi chu ^_^
 */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studentsocial/models/object/schedule.dart';
import 'package:studentsocial/support/dialog_support.dart';
import 'package:studentsocial/support/platform_channel.dart';
import 'package:studentsocial/viewmodels/main_viewmodel.dart';
import 'package:provider/provider.dart';

class AddNote extends StatefulWidget {
  final DateTime date;
  final BuildContext context;

  AddNote({this.date, this.context});

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> with DialogSupport {
  final dateFormat = DateFormat("yyyy-MM-dd");
  DateTime _date;

  //khai bao bien formkey de quan li,validate from them ghi chu
  final formKey = GlobalKey<FormState>();

  //khai bao bien cho phan ghi chu
  String _title = '', _content = '';

  MainViewModel _mainViewModel;

  _initViewModel() {
    _mainViewModel = Provider.of<MainViewModel>(widget.context);
  }

  @override
  void initState() {
    super.initState();
    _date = widget.date;
  }

  /*
   * xu ly su kien khi bam them ghi chu
   */
  void _actionThemGhiChu() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      String schedule = Schedule.forNote(
          _mainViewModel.getMSV,
          _title == '' ? 'Tiêu đề' : _title,
          _content == '' ? 'Nội dung' : _content,
          dateFormat.format(_date));
      try {
        String value = await PlatformChannel.database.invokeMethod(
            PlatformChannel.addNote, <String, String>{'note': schedule});
        print('add note :$value');
        _mainViewModel.loadCurrentMSV();
      } catch (e) {
        print('add note: $e');
      }
      pop(context);
    }
  }

  /*
   * show picker time
   */
  Future<Null> _pickerTime() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2000),
        lastDate: DateTime(9999));
    if (picked != null && picked != _date) {
      print('date selected is ${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  /*
   * cac widget con
   */

  TextFormField _noteTitle() {
    return TextFormField(
      key: Key('tieudeghichu'),
      maxLines: 1,
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
      onSaved: (value) => _title = value,
      decoration: InputDecoration(
          hintText: 'Tiêu đề (không bắt buộc)',
          labelText: 'Tiêu đề (không bắt buộc)',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }

  TextFormField _noteContent() {
    return TextFormField(
      key: Key('noidungghichu'),
      maxLines: 2,
      onSaved: (value) => _content = value,
      decoration: InputDecoration(
          hintText: 'Nội dung (không bắt buộc)',
          labelText: 'Nội dung (không bắt buộc)',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }

  Wrap _datePicker() {
    return Wrap(
      children: <Widget>[
        RaisedButton(
          child: Text(
            dateFormat.format(_date),
            style: TextStyle(color: Colors.white),
          ),
          onPressed: null,
          color: Colors.blue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
        SizedBox(
          width: 10,
        ),
        RaisedButton(
          child: Text(
            'Chọn ngày',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _pickerTime();
          },
          color: Colors.blue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _initViewModel();

    return AlertDialog(
      title: Text('Thêm lịch cá nhân'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _noteTitle(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                  ),
                  _noteContent(),
                  Padding(
                    padding: const EdgeInsets.all(8),
                  ),
                  _datePicker()
                ]),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          key: Key('ghichu_no'),
          child: Text(
            'Hủy bỏ',
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            pop(context);
          },
        ),
        FlatButton(key: Key('ghichu_yes'),child: Text('Thêm mới'), onPressed: _actionThemGhiChu)
      ],
    );
  }
}
