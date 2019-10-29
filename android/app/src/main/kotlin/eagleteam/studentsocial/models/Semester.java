package eagleteam.studentsocial.models;


public class Semester {
    private String maKy;
    private String tenKy;
    private boolean kyHienTai;

    public Semester(String maKy, String tenKy, boolean kyHienTai) {
        this.maKy = maKy;
        this.tenKy = tenKy;
        this.kyHienTai = kyHienTai;
    }

    public String getMaKy() {
        return maKy;
    }

    public void setMaKy(String maKy) {
        this.maKy = maKy;
    }

    public String getTenKy() {
        String[] temp = tenKy.split("_");
        return "Kỳ " + temp[0] + " năm " + temp[1] + " - " + temp[2];
    }

    public void setTenKy(String tenKy) {
        this.tenKy = tenKy;
    }

    public boolean isKyHienTai() {
        return kyHienTai;
    }

    public void setKyHienTai(boolean kyHienTai) {
        this.kyHienTai = kyHienTai;
    }
}
