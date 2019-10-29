package eagleteam.studentsocial.database;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import eagleteam.studentsocial.models.Mark;
import eagleteam.studentsocial.models.Schedule;
import eagleteam.studentsocial.models.User;

@Database(entities = {User.class, Schedule.class, Mark.class}, version = 1, exportSchema = false)
public abstract class StudentSocialDatabase extends RoomDatabase {
    private static StudentSocialDatabase instance;

    public abstract ScheduleDao scheduleDao();

    public abstract MarkDao markDao();

    public abstract UserDao userDao();

    public static StudentSocialDatabase getInstance(Context context) {
        if (instance == null) {
            instance = Room.databaseBuilder(
                    context.getApplicationContext(), StudentSocialDatabase.class, "studentsocial_database"
            ).build();
        }
        return instance;
    }
}
