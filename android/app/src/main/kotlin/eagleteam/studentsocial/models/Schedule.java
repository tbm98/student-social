package eagleteam.studentsocial.models;

import androidx.annotation.NonNull;
import androidx.room.ColumnInfo;
import androidx.room.Entity;
import androidx.room.Ignore;
import androidx.room.PrimaryKey;

@Entity(tableName = "schedule_table")
public class Schedule {
    @PrimaryKey(autoGenerate = true)
    @NonNull
    private int ID;

    @ColumnInfo(name = "MaSinhVien")
    private String MaSinhVien;

    @ColumnInfo(name = "MaMon")
    private String MaMon;

    @ColumnInfo(name = "TenMon")
    private String TenMon;

    @ColumnInfo(name = "ThoiGian")
    private String ThoiGian;

    @ColumnInfo(name = "Ngay")
    private String Ngay;

    @ColumnInfo(name = "DiaDiem")
    private String DiaDiem;

    @ColumnInfo(name = "HinhThuc")
    private String HinhThuc;

    @ColumnInfo(name = "GiaoVien")
    private String GiaoVien;

    @ColumnInfo(name = "LoaiLich")
    private String LoaiLich;

    @ColumnInfo(name = "SoBaoDanh")
    private String SoBaoDanh;

    @ColumnInfo(name = "SoTinChi")
    private String SoTinChi;

    public Schedule(int ID, String MaSinhVien, String MaMon, String TenMon, String ThoiGian, String Ngay, String DiaDiem, String HinhThuc, String GiaoVien, String LoaiLich, String SoBaoDanh, String SoTinChi) {
        this.ID = ID;
        this.MaSinhVien = MaSinhVien;
        this.MaMon = MaMon;
        this.TenMon = TenMon;
        this.ThoiGian = ThoiGian;
        this.Ngay = Ngay;
        this.DiaDiem = DiaDiem;
        this.HinhThuc = HinhThuc;
        this.GiaoVien = GiaoVien;
        this.LoaiLich = LoaiLich;
        this.SoBaoDanh = SoBaoDanh;
        this.SoTinChi = SoTinChi;
    }

    @Ignore
    public Schedule(String MaSinhVien, String MaMon, String TenMon, String ThoiGian, String Ngay, String DiaDiem, String HinhThuc, String GiaoVien, String LoaiLich, String SoBaoDanh, String SoTinChi) {
        this.MaSinhVien = MaSinhVien;
        this.MaMon = MaMon;
        this.TenMon = TenMon;
        this.ThoiGian = ThoiGian;
        this.Ngay = Ngay;
        this.DiaDiem = DiaDiem;
        this.HinhThuc = HinhThuc;
        this.GiaoVien = GiaoVien;
        this.LoaiLich = LoaiLich;
        this.SoBaoDanh = SoBaoDanh;
        this.SoTinChi = SoTinChi;
    }

    public void setMoreDetail(String maSinhVien, String tenMon) {
        this.MaSinhVien = maSinhVien;
        this.TenMon = tenMon;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getMaSinhVien() {
        return MaSinhVien == null ? "" : MaSinhVien;
    }

    public void setMaSinhVien(String MaSinhVien) {
        this.MaSinhVien = MaSinhVien;
    }

    public String getMaMon() {
        return MaMon == null ? "" : MaMon;
    }

    public void setMaMon(String MaMon) {
        this.MaMon = MaMon;
    }

    public String getTenMon() {
        return TenMon == null ? "" : TenMon;
    }

    public void setTenMon(String TenMon) {
        this.TenMon = TenMon;
    }

    public String getThoiGian() {
        return ThoiGian == null ? "" : ThoiGian;
    }

    public void setThoiGian(String ThoiGian) {
        this.ThoiGian = ThoiGian;
    }

    public String getNgay() {
        return Ngay == null ? "" : Ngay;
    }

    public void setNgay(String Ngay) {
        this.Ngay = Ngay;
    }

    public String getDiaDiem() {
        return DiaDiem == null ? "" : DiaDiem;
    }

    public void setDiaDiem(String DiaDiem) {
        this.DiaDiem = DiaDiem;
    }

    public String getHinhThuc() {
        return HinhThuc == null ? "" : HinhThuc;
    }

    public void setHinhThuc(String HinhThuc) {
        this.HinhThuc = HinhThuc;
    }

    public String getGiaoVien() {
        return GiaoVien == null ? "" : GiaoVien;
    }

    public void setGiaoVien(String GiaoVien) {
        this.GiaoVien = GiaoVien;
    }

    public String getLoaiLich() {
        return LoaiLich == null ? "" : LoaiLich;
    }

    public void setLoaiLich(String LoaiLich) {
        this.LoaiLich = LoaiLich;
    }

    public String getSoBaoDanh() {
        return SoBaoDanh == null ? "" : SoBaoDanh;
    }

    public void setSoBaoDanh(String SoBaoDanh) {
        this.SoBaoDanh = SoBaoDanh;
    }

    public String getSoTinChi() {
        return SoTinChi == null ? "" : SoTinChi;
    }

    public void setSoTinChi(String SoTinChi) {
        this.SoTinChi = SoTinChi;
    }

    @NonNull
    @Override
    public String toString() {
        String value = "MaMon:" + getMaMon() + "\n" +
                "TenMon:" + getTenMon() + "\n" +
                "ThoiGian:" + getThoiGian() + "\n" +
                "Ngay:" + getNgay() + "\n" +
                "DiaDiem:" + getDiaDiem() + "\n" +
                "HinhThuc:" + getHinhThuc() + "\n" +
                "GiaoVien:" + getGiaoVien() + "\n" +
                "LoaiLich:" + getLoaiLich() + "\n" +
                "SoBaoDanh:" + getSoBaoDanh() + "\n" +
                "SoTinChi:" + getSoTinChi();
        return value;
    }

    public boolean equal(Schedule schedule) {
        return getMaSinhVien().equals(schedule.getMaSinhVien()) &&
                getMaMon().equals(schedule.getMaMon()) &&
                getTenMon().equals(schedule.getTenMon()) &&
                getThoiGian().equals(schedule.getThoiGian()) &&
                getNgay().equals(schedule.getNgay()) &&
                getDiaDiem().equals(schedule.getDiaDiem()) &&
                getHinhThuc().equals(schedule.getHinhThuc()) &&
                getGiaoVien().equals(schedule.getGiaoVien()) &&
                getLoaiLich().equals(schedule.getLoaiLich()) &&
                getSoBaoDanh().equals(schedule.getSoBaoDanh()) &&
                getSoTinChi().equals(schedule.getSoTinChi());
    }
}
