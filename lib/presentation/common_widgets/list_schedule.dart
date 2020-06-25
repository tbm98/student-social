import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studentsocial/helpers/logging.dart';

import '../../helpers/date.dart';
import '../../helpers/dialog_support.dart';
import '../../models/entities/schedule.dart';
import '../../viewmodels/calendar_viewmodel.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import '../screens/main/main_state_notifier.dart';

class ListSchedule extends StatefulWidget {
  @override
  _ListScheduleState createState() => _ListScheduleState();
}

class _ListScheduleState extends State<ListSchedule> with DialogSupport {
  DateSupport dateSupport = DateSupport();
  MainStateNotifier _mainViewModel;
  ScheduleViewModel _listScheduleViewModel;
  CalendarViewModel _calendarViewModel;
  TextEditingController _titleController;
  TextEditingController _contentController;

  void _initViewModel() {
    _mainViewModel = Provider.of<MainStateNotifier>(context);
    _calendarViewModel = Provider.of<CalendarViewModel>(context);
    _listScheduleViewModel = Provider.of<ScheduleViewModel>(context);
    _listScheduleViewModel.addCalendarViewModel(_calendarViewModel);
  }

  String _tiet() {
    return dateSupport.getTiet(_mainViewModel.getMSV).toString();
  }

  Widget layoutLichHoc(Schedule entri) {
    if (entri.ThoiGian.split(',').contains(_tiet())) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                height: 30,
                padding:
                    const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Tiết'),
                    CircleAvatar(
                      child: Text(_tiet()),
                    ),
                    const Text('đang diễn ra')
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8))),
              child: Text(
                entri.HocPhan,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
              child: Text(
                  '• Thời gian: ${entri.TietHoc} ${dateSupport.getThoiGian(entri.TietHoc, _mainViewModel.getMSV)}'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
              child: Text(
                '• Địa điểm: ${entri.DiaDiem}',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
              child: Text(
                '• Giảng viên: ${entri.GiaoVien}',
              ),
            )
          ]);
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            child: Text(
              entri.HocPhan,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
            child: Text(
                '• Thời gian: ${entri.TietHoc} ${this.dateSupport.getThoiGian(entri.TietHoc, _mainViewModel.getMSV)}'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
            child: Text(
              '• Địa điểm: ${entri.DiaDiem}',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
            child: Text(
              '• Giảng viên: ${entri.GiaoVien}',
            ),
          )
        ],
      );
    }
  }

  Widget layoutLichThi(Schedule entri) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Text(
            entri.HocPhan,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
          child: Text(
            '• Số báo danh: ${entri.SoBaoDanh}',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
          child: Text(
            '• Thời gian: ${entri.TietHoc.replaceAll('\n', ' ')}',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
          child: Text(
            '• Địa điểm: ${entri.DiaDiem}',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 2, bottom: 2),
          child: Text(
            '• Hình thức: ${entri.HinhThuc}',
          ),
        )
      ],
    );
  }

  Widget layoutNote(Schedule entri) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          decoration: const BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _confirmDeleteNote(entri);
                },
                child: const Icon(
                  Icons.delete,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _titleController = TextEditingController(text: entri.MaMon);
                  _contentController =
                      TextEditingController(text: entri.ThoiGian);
                  _showEditNote(entri);
                },
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    entri.MaMon,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Text(entri.ThoiGian),
        )
      ],
    );
  }

  void _confirmDeleteNote(Schedule note) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text('Xác nhận xoá ghi chú này ?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    pop(context);
                  },
                  child: const Text(
                    'Huỷ',
                    style: TextStyle(color: Colors.red),
                  )),
              FlatButton(
                  onPressed: () async {
                    //TODO: Xoa ghi chu
//                    String value = await PlatformChannel.database.invokeMethod(
//                        PlatformChannel.removeOneSchedule,
//                        <String, String>{'data': note.toStringForNote()});
                    pop(context);
//                    if (value.contains('ERROR')) {
//                      await showSuccess(context,'Xoá ghi chú bị lỗi $value');
//                    } else {
//                      await showSuccess(context,'Xoá ghi chú thành công !');
//                    }
                    await _mainViewModel.loadCurrentMSV();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  /*
   * cac widget con
   */

  TextField _title(String title) {
    return TextField(
      controller: _titleController,
      maxLines: 1,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      decoration: const InputDecoration(
          hintText: 'Tiêu đề (không bắt buộc)',
          labelText: 'Tiêu đề (không bắt buộc)',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }

  TextField _content(String content) {
    return TextField(
      controller: _contentController,
      maxLines: 2,
      decoration: const InputDecoration(
          hintText: 'Nội dung (không bắt buộc)',
          labelText: 'Nội dung (không bắt buộc)',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)))),
    );
  }

  void _showEditNote(Schedule note) {
    final dialog = AlertDialog(
      title: const Text('Sửa ghi chú'),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: _title(note.MaMon),
                ),
                const Padding(
                  padding: EdgeInsets.all(8),
                ),
                _content(note.ThoiGian),
              ]),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            pop(context);
          },
          child: const Text(
            'Huỷ',
            style: TextStyle(color: Colors.red),
          ),
        ),
        FlatButton(
          onPressed: () async {
            note.MaMon = _titleController.text;
            note.ThoiGian = _contentController.text;
            //TODO: sua ghi chu
//              String value = await PlatformChannel.database.invokeMethod(
//                  PlatformChannel.updateOneSchedule,
//                  <String, String>{'data': note.toStringForNote()});
            pop(context);
//              if (value.contains('ERROR')) {
//                showSuccess(context,'Sửa ghi chú bị lỗi: $value');
//              } else {
//                showSuccess(context,'Sửa ghi chú thành công !');
//                _mainViewModel.loadCurrentMSV();
//              }
          },
          child: const Text('Sửa'),
        )
      ],
    );
    showDialog(context: context, builder: (_) => dialog);
  }

  Color getColor(String LoaiLich) {
    switch (LoaiLich) {
      case 'LichHoc':
        return Colors.blue;
      case 'LichThi':
        return Colors.red;
      case 'Note':
        return Colors.purple;
    }
    return Colors.blue; // blue by default
  }

  Widget getLayoutEntri(Schedule entri) {
    switch (entri.LoaiLich) {
      case 'LichHoc':
        return layoutLichHoc(entri);
      case 'LichThi':
        return layoutLichThi(entri);
      case 'Note':
        return layoutNote(entri);
    }
    return null;
  }

  Widget ngayNghi() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hôm nay bạn được nghỉ ',
              style: TextStyle(fontSize: 20, color: Colors.green),
            ),
            SizedBox(
                width: 30, height: 30, child: Image.asset('image/smile.png'))
          ],
        ),
        const Text('(EagleTeam)')
      ],
    ));
  }

  Widget ngayHoc(List<Schedule> entries) {
    logs(entries);
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ListView.builder(
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              elevation: 8,
              child: getLayoutEntri(entries[index]),
            );
          }),
    );
  }

  Widget listSchedule(List<Schedule> entries) {
    if (entries.isEmpty) {
      return ngayNghi();
    }
    return ngayHoc(entries);
  }

  Widget _layoutPageViewSchedule() {
    return PageView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _layoutItemPage(index);
      },
      controller: _listScheduleViewModel.getPageController,
      onPageChanged: (int value) {
        _listScheduleViewModel.onPageChanged(value);
      },
    );
  }

  Widget _layoutItemPage(int index) {
    if (_mainViewModel.getEntriesOfDay == null) {
      return listSchedule(<Schedule>[]);
    }
    //tính toán lấy ra lịch của page hiện tại
    //công thức sẽ là lấy ngày hiện tại +- đi biên độ lệch của currentPage so với 5000
    final int delta = index - 5000;
    final DateTime dateTime = delta < 0
        ? DateTime.now().subtract(Duration(days: -delta))
        : DateTime.now().add(Duration(days: delta));
    final String key = DateFormat('dd/MM/yyyy').format(dateTime);
    final List<Schedule> entries = _mainViewModel.getEntriesOfDay[key];

    if (entries == null) {
      return listSchedule(<Schedule>[]);
    }
    //lọc những tiết bị trùng
    for (int i = 0; i < entries.length - 1; i++) {
      for (int j = i + 1; j < entries.length; j++) {
        if (entries[j].equals(entries[i])) {
          entries.removeAt(j);
          j--;
        }
      }
    }
    entries.sort((Schedule a, Schedule b) => a.ThoiGian.compareTo(b.ThoiGian));
    return listSchedule(entries);
  }

  @override
  Widget build(BuildContext context) {
    _initViewModel();
    return _layoutPageViewSchedule();
  }
}
