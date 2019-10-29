package eagleteam.studentsocial.database;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

import eagleteam.studentsocial.models.Schedule;
import eagleteam.studentsocial.models.User;

@Dao
public interface ScheduleDao {
    @Insert
    void insertListSchedules(List<Schedule> listSchedules);

    @Insert
    void insertOnlySchedule(Schedule schedule);

    @Update
    void updateOnlySchedule(Schedule schedule);

    @Delete
    void deleteOnlySchedule(Schedule schedule);

    @Query("select * from schedule_table where MaSinhVien = :msv")
    List<Schedule> getAllSchedules(String msv);

    @Query("delete from schedule_table")
    void deleteAllSchedules();

    @Query("select count(*) from schedule_table")
    int countSchedules();

    @Query("delete from schedule_table where MaSinhVien = :msv")
    void deleteScheduleByMSV(String msv);

    @Query("delete from schedule_table where MaSinhVien = :msv and LoaiLich != 'Note'")
    void deleteScheduleByMSVWithOutNote(String msv);

    @Query("select * from schedule_table where MaSinhVien = :msv and Ngay == :strDate")
    List<Schedule> getAllSchedulesFromDate(String msv, String strDate);
}
