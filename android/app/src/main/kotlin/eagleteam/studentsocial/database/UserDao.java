package eagleteam.studentsocial.database;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import androidx.room.Update;

import java.util.List;

import eagleteam.studentsocial.models.User;


@Dao
public interface UserDao {
    @Insert
    void insertOnlyUser(User user);

    @Update
    void updateOnlyUser(User user);

    @Delete
    void deleteOnlyUser(User user);

    @Query("select * from user_table where MaSinhVien = :maSinhVien")
    User getUserByMaSinhVien(String maSinhVien);

    @Query("delete from user_table")
    void deleteAllUser();

    @Query("delete from user_table where MaSinhVien = :msv")
    void deleteUserByMSV(String msv);

    @Query("select * from user_table")
    List<User> getAllUsers();
}
