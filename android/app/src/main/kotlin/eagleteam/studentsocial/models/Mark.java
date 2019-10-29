package eagleteam.studentsocial.models;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Ignore;
import androidx.room.PrimaryKey;

@Entity(tableName = "mark_table")
public class Mark {
    @PrimaryKey(autoGenerate = true)
    @NonNull
    private int ID;

    @ColumnInfo(name = "MaSinhVien")
    private String MaSinhVien;

    @ColumnInfo(name = "MaMon")
    private String MaMon;

    @ColumnInfo(name = "TenMon")
    private String TenMon;

    @ColumnInfo(name = "SoTinChi")
    private String SoTinChi;

    @ColumnInfo(name = "CC")
    private String CC;

    @ColumnInfo(name = "KT")
    private String KT;

    @ColumnInfo(name = "THI")
    private String THI;

    @ColumnInfo(name = "TKHP")
    private String TKHP;

    @ColumnInfo(name = "DiemChu")
    private String DiemChu;



    @Ignore
    public Mark(String MaSinhVien, String MaMon, String TenMon, String SoTinChi, String CC, String KT, String THI, String TKHP, String DiemChu) {
        this.MaSinhVien = MaSinhVien;
        this.MaMon = MaMon;
        this.TenMon = TenMon;
        this.SoTinChi = SoTinChi;
        this.CC = CC;
        this.KT = KT;
        this.THI = THI;
        this.TKHP = TKHP;
        this.DiemChu = DiemChu;
    }

    public void setID(int ID) {
        this.ID = ID;
    }
    public int getID() {
        return ID;
    }

    public Mark(int ID, String MaSinhVien, String MaMon, String TenMon, String SoTinChi, String CC, String KT, String THI, String TKHP, String DiemChu) {
        this.ID = ID;
        this.MaSinhVien = MaSinhVien;
        this.MaMon = MaMon;
        this.TenMon = TenMon;
        this.SoTinChi = SoTinChi;
        this.CC = CC;
        this.KT = KT;
        this.THI = THI;
        this.TKHP = TKHP;
        this.DiemChu = DiemChu;
    }

    public void setMoreDetail(String MaSinhVien,String TenMon,String SoTinChi){
        this.MaSinhVien = MaSinhVien;
        this.TenMon = TenMon;
        this.SoTinChi = SoTinChi;
    }

    public void setMaSinhVien(String MaSinhVien) {
        this.MaSinhVien = MaSinhVien;
    }

    public String getMaSinhVien() {
        return MaSinhVien;
    }

    public String getMaMon() {
        return MaMon;
    }

    public void setMaMon(@NonNull String MaMon) {
        this.MaMon = MaMon;
    }

    public String getTenMon() {
        return TenMon;
    }

    public void setTenMon(String TenMon) {
        this.TenMon = TenMon;
    }

    public String getSoTinChi() {
        return SoTinChi;
    }

    public void setSoTinChi(String SoTinChi) {
        this.SoTinChi = SoTinChi;
    }

    public String getCC() {
        return CC;
    }

    public void setCC(String CC) {
        this.CC = CC;
    }

    public String getKT() {
        return KT;
    }

    public void setKT(String KT) {
        this.KT = KT;
    }

    public String getTHI() {
        return THI;
    }

    public void setTHI(String THI) {
        this.THI = THI;
    }

    public String getTKHP() {
        return TKHP;
    }

    public void setTKHP(String TKHP) {
        this.TKHP = TKHP;
    }

    public String getDiemChu() {
        return DiemChu;
    }

    public void setDiemChu(String DiemChu) {
        this.DiemChu = DiemChu;
    }

    @NonNull
    @Override
    public String toString() {
        return "ma sinh vien:"+ MaSinhVien +"\n" +
                "ma mon:"+MaMon+"\n" +
                "ten mon:"+TenMon;
    }
}
