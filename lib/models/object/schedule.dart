class Schedule {
  final String ID;

  final String MaSinhVien;

  String MaMon;

  final String TenMon;

  String ThoiGian;

  final String Ngay;

  final String DiaDiem;

  final String HinhThuc;

  final String GiaoVien;

  final String LoaiLich;

  final String SoBaoDanh;

  final String SoTinChi;

  Schedule(
      {this.ID,
      this.MaSinhVien,
      this.MaMon,
      this.TenMon,
      this.ThoiGian,
      this.Ngay,
      this.DiaDiem,
      this.HinhThuc,
      this.GiaoVien,
      this.LoaiLich,
      this.SoBaoDanh,
      this.SoTinChi});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      ID: json['ID'].toString(),
      MaSinhVien: json['MaSinhVien'],
      MaMon: json['MaMon'],
      TenMon: json['TenMon'],
      ThoiGian: json['ThoiGian'],
      Ngay: json['Ngay'],
      DiaDiem: json['DiaDiem'],
      HinhThuc: json['HinhThuc'],
      GiaoVien: json['GiaoVien'],
      LoaiLich: json['LoaiLich'],
      SoBaoDanh: json['SoBaoDanh'].toString(),
      SoTinChi: json['SoTinChi'].toString(),
    );
  }

  //sinh chuỗi để tạo 1 note mới
  static String forNote(
      String msv, String tieuDe, String noiDung, String ngay) {
    return "{\"MaSinhVien\":\"$msv\",\"MaMon\":\"$tieuDe\",\"ThoiGian\":\"$noiDung\",\"Ngay\":\"$ngay\",\"LoaiLich\":\"Note\"}";
  }

  //sinh chuỗi để tạo note từ object hiện có
  String toStringForNote() {
    return "{\"ID\":\"$ID\",\"MaSinhVien\":\"$MaSinhVien\",\"MaMon\":\"$MaMon\",\"TenMon\":\"$TenMon\",\"ThoiGian\":\"$ThoiGian\",\"Ngay\":\"$Ngay\",\"DiaDiem\":\"$DiaDiem\",\"HinhThuc\":\"$HinhThuc\",\"GiaoVien\":\"$GiaoVien\",\"LoaiLich\":\"$LoaiLich\",\"SoBaoDanh\":\"$SoBaoDanh\",\"SoTinChi\":\"$SoTinChi\"}";
  }

  bool equals(Schedule schedule) {
    return MaSinhVien == schedule.MaSinhVien &&
        MaMon == schedule.MaMon &&
        TenMon == schedule.TenMon &&
        ThoiGian == schedule.ThoiGian &&
        Ngay == schedule.Ngay &&
        DiaDiem == schedule.DiaDiem &&
        HinhThuc == schedule.HinhThuc &&
        GiaoVien == schedule.GiaoVien &&
        LoaiLich == schedule.LoaiLich &&
        SoBaoDanh == schedule.SoBaoDanh &&
        SoTinChi == schedule.SoTinChi;
  }
}
