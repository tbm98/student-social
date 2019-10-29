package eagleteam.studentsocial.database;

import androidx.room.Dao;
import androidx.room.Insert;
import androidx.room.Query;

import java.util.List;

import eagleteam.studentsocial.models.Mark;

@Dao
public interface MarkDao {
    @Insert
    void insertListMarks(List<Mark> listMarks);

    @Query("select * from mark_table where MaSinhVien = :maSV")
    List<Mark> getListMarksByMaSV(String maSV);

    @Query("delete from mark_table where MaSinhVien = :maSV")
    void deleteListMarksByMaSV(String maSV);

    @Query("delete from mark_table")
    void deleteAllMarks();

}
