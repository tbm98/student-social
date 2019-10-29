package eagleteam.studentsocial.models;

public class StudentProfile {
    private String maSinhVien;

    private String hoTen;

    private String nienKhoa;

    private String lop;

    private String nganh;

    private String truong;

    private String heDaoTao;

    public StudentProfile(String maSinhVien, String hoTen, String nienKhoa, String lop, String nganh, String truong, String heDaoTao) {
        this.maSinhVien = maSinhVien;
        this.hoTen = hoTen;
        this.nienKhoa = nienKhoa;
        this.lop = lop;
        this.nganh = nganh;
        this.truong = truong;
        this.heDaoTao = heDaoTao;
    }

    public String getMaSinhVien() {
        return maSinhVien;
    }

    public void setMaSinhVien(String maSinhVien) {
        this.maSinhVien = maSinhVien;
    }

    public String getHoTen() {
        hoTen = hoTen.trim().replaceAll("\\s+", " ");
        if (maSinhVien.trim().equals("DTC165D4801030254"))
            return "TUyenOC";
        if (maSinhVien.trim().equals("DTC165D4801030252"))
            return "TBM.98";
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getNienKhoa() {
        return nienKhoa;
    }

    public void setNienKhoa(String nienKhoa) {
        this.nienKhoa = nienKhoa;
    }

    public String getLop() {
        return lop;
    }

    public void setLop(String lop) {
        this.lop = lop;
    }

    public String getNganh() {
        return nganh;
    }

    public void setNganh(String nganh) {
        this.nganh = nganh;
    }

    public String getTruong() {
        return truong;
    }

    public void setTruong(String truong) {
        this.truong = truong;
    }

    public String getHeDaoTao() {
        return heDaoTao;
    }

    public void setHeDaoTao(String heDaoTao) {
        this.heDaoTao = heDaoTao;
    }
}
