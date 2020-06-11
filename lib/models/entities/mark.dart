class Mark {
  final String ID;
  final String MaSinhVien;
  final String MaMon;
  final String TenMon;
  final String SoTinChi;
  final String CC;
  final String KT;
  final String THI;
  final String TKHP;
  final String DiemChu;

  Mark(
      {this.ID,
      this.MaSinhVien,
      this.MaMon,
      this.TenMon,
      this.SoTinChi,
      this.CC,
      this.KT,
      this.THI,
      this.TKHP,
      this.DiemChu});

  factory Mark.fromJson(Map<String, dynamic> json) {
    return Mark(
        ID: json['ID'].toString(),
        MaSinhVien: json['MaSinhVien'],
        MaMon: json['MaMon'],
        TenMon: json['TenMon'],
        SoTinChi: json['SoTinChi'].toString(),
        CC: json['CC'].toString(),
        KT: json['KT'].toString(),
        THI: json['THI'].toString(),
        TKHP: json['TKHP'].toString(),
        DiemChu: json['DiemChu'].toString());
  }
}
