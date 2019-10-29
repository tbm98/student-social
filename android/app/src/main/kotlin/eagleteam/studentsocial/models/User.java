package eagleteam.studentsocial.models;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Ignore;
import androidx.room.PrimaryKey;

@Entity(tableName = "user_table")
public class User {
    @PrimaryKey
    @NonNull
    @ColumnInfo(name = "MaSinhVien")
    private String MaSinhVien;
    @ColumnInfo(name = "HoTen")
    private String HoTen;
    @ColumnInfo(name = "NienKhoa")
    private String NienKhoa;
    @ColumnInfo(name = "Lop")
    private String Lop;
    @ColumnInfo(name = "Nganh")
    private String Nganh;
    @ColumnInfo(name = "Truong")
    private String Truong;
    @ColumnInfo(name = "HeDaoTao")
    private String HeDaoTao;
    @ColumnInfo(name = "TongTC")
    private String TongTC;
    @ColumnInfo(name = "STCTD")
    private String STCTD;
    @ColumnInfo(name = "STCTLN")
    private String STCTLN;
    @ColumnInfo(name = "DTBC")
    private String DTBC;
    @ColumnInfo(name = "DTBCQD")
    private String DTBCQD;
    @ColumnInfo(name = "SoMonKhongDat")
    private String SoMonKhongDat;
    @ColumnInfo(name = "SoTCKhongDat")
    private String SoTCKhongDat;
    @ColumnInfo(name = "Token")
    private String Token;

    @Ignore
    public User() {
    }

    public User(@NonNull String MaSinhVien, String HoTen, String NienKhoa, String Lop, String Nganh, String Truong, String HeDaoTao, String TongTC, String STCTD, String STCTLN, String DTBC, String DTBCQD, String SoMonKhongDat, String SoTCKhongDat, String Token) {
        this.MaSinhVien = MaSinhVien;
        this.HoTen = HoTen;
        this.NienKhoa = NienKhoa;
        this.Lop = Lop;
        this.Nganh = Nganh;
        this.Truong = Truong;
        this.HeDaoTao = HeDaoTao;
        this.TongTC = TongTC;
        this.STCTD = STCTD;
        this.STCTLN = STCTLN;
        this.DTBC = DTBC;
        this.DTBCQD = DTBCQD;
        this.SoMonKhongDat = SoMonKhongDat;
        this.SoTCKhongDat = SoTCKhongDat;
        this.Token = Token;
    }

    @NonNull
    public String getMaSinhVien() {
        return MaSinhVien;
    }

    public void setMaSinhVien(@NonNull String maSinhVien) {
        this.MaSinhVien = maSinhVien;
    }

    public String getHoTen() {
        return HoTen;
    }

    public void setHoTen(String hoTen) {
        HoTen = hoTen;
    }

    public String getNienKhoa() {
        return NienKhoa;
    }

    public void setNienKhoa(String nienKhoa) {
        NienKhoa = nienKhoa;
    }

    public String getLop() {
        return Lop;
    }

    public void setLop(String lop) {
        Lop = lop;
    }

    public String getNganh() {
        return Nganh;
    }

    public void setNganh(String nganh) {
        Nganh = nganh;
    }

    public String getTruong() {
        return Truong;
    }

    public void setTruong(String truong) {
        Truong = truong;
    }

    public String getHeDaoTao() {
        return HeDaoTao;
    }

    public void setHeDaoTao(String heDaoTao) {
        HeDaoTao = heDaoTao;
    }

    public String getTongTC() {
        return TongTC;
    }

    public void setTongTC(String tongTC) {
        TongTC = tongTC;
    }

    public String getSTCTD() {
        return STCTD;
    }

    public void setSTCTD(String STCTD) {
        this.STCTD = STCTD;
    }

    public String getSTCTLN() {
        return STCTLN;
    }

    public void setSTCTLN(String STCTLN) {
        this.STCTLN = STCTLN;
    }

    public String getDTBC() {
        return DTBC;
    }

    public void setDTBC(String DTBC) {
        this.DTBC = DTBC;
    }

    public String getDTBCQD() {
        return DTBCQD;
    }

    public void setDTBCQD(String DTBCQD) {
        this.DTBCQD = DTBCQD;
    }

    public String getSoMonKhongDat() {
        return SoMonKhongDat;
    }

    public void setSoMonKhongDat(String soMonKhongDat) {
        SoMonKhongDat = soMonKhongDat;
    }

    public String getSoTCKhongDat() {
        return SoTCKhongDat;
    }

    public void setSoTCKhongDat(String soTCKhongDat) {
        SoTCKhongDat = soTCKhongDat;
    }

    public String getToken() {
        return Token;
    }

    public void setToken(String token) {
        this.Token = token;
    }
}
