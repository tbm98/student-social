class Profile {
  final String MaSinhVien;
  final String HoTen;
  final String NienKhoa;
  final String Lop;
  final String Nganh;
  final String Truong;
  final String HeDaoTao;
  String TongTC;
  String STCTD;
  String STCTLN;
  String DTBC;
  String DTBCQD;
  String SoMonKhongDat;
  String SoTCKhongDat;
  String Token;

  Profile(
      {this.MaSinhVien,
      this.HoTen,
      this.NienKhoa,
      this.Lop,
      this.Nganh,
      this.Truong,
      this.HeDaoTao});

  void setMoreDetail(
      tongtc, stctd, stctln, dtbc, dtbcqd, somonkhongdat, sotckhongdat,token) {
    this.TongTC = tongtc.toString();
    this.STCTD = stctd.toString();
    this.STCTLN = stctln.toString();
    this.DTBC = dtbc.toString();
    this.DTBCQD = dtbcqd.toString();
    this.SoMonKhongDat = somonkhongdat.toString();
    this.SoTCKhongDat = sotckhongdat.toString();
    this.Token = token;
  }
  void setMoreDetailByJson(Map<String,dynamic> json) {
    this.TongTC = json['TongTC'].toString();
    this.STCTD = json['STCTD'].toString();
    this.STCTLN = json['STCTLN'].toString();
    this.DTBC = json['DTBC'].toString();
    this.DTBCQD = json['DTBCQD'].toString();
    this.SoMonKhongDat = json['SoMonKhongDat'].toString();
    this.SoTCKhongDat = json['SoTCKhongDat'].toString();
    this.Token = json['Token'].toString();
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
        MaSinhVien: json['MaSinhVien'].toString(),
        HoTen: json['HoTen'].toString(),
        NienKhoa: json['NienKhoa'].toString(),
        Lop: json['Lop'].toString(),
        Nganh: json['Nganh'].toString(),
        Truong: json['Truong'].toString(),
        HeDaoTao: json['HeDaoTao'].toString());
  }
  static String toGuest(){
//    return Profile(MaSinhVien: "guest",HoTen: "Người dùng thông thường",NienKhoa: "",Lop: "",Nganh: "",Truong: "",HeDaoTao: "");
    return '{"MaSinhVien":"guest","HoTen":"Người dùng thông thường","NienKhoa":"","Lop":"","Nganh":"","Truong":"","HeDaoTao":"","TongTC":"","STCTD":"","STCTLN":"","DTBC":"","DTBCQD":"","SoMonKhongDat":"","SoTCKhongDat":"","Token":""}';
  }
  toJson(){
    return {
      'Token':Token,
      'TongTC':TongTC,
      'STCTD':STCTD,
      'STCTLN':STCTLN,
      'DTBC':DTBC,
      'DTBCQD':DTBCQD,
      'SoMonKhongDat':SoMonKhongDat,
      'SoTCKhongDat':SoTCKhongDat,
      'MaSinhVien':MaSinhVien,
      'HoTen':HoTen,
      'NienKhoa':NienKhoa,
      'Lop':Lop,
      'Nganh':Nganh,
      'Truong':Truong,
      'HeDaoTao':HeDaoTao
    };
  }
}
