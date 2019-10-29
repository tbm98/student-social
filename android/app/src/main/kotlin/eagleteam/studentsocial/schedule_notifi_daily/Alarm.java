//package eagleteam.studentsocial.schedule_notifi_daily;
//
//import android.app.AlarmManager;
//import android.app.PendingIntent;
//import android.content.Context;
//import android.content.Intent;
//import android.content.SharedPreferences;
//import android.os.Build;
//import android.provider.AlarmClock;
//
//import java.util.Calendar;
//
//import static eagleteam.studentsocial.platform_channel.PlatformChannel.shared;
//
//public class Alarm {
//    public static void create(Context context) {
//        SharedPreferences sharedPreferences = context.getSharedPreferences(shared,Context.MODE_PRIVATE);
//        Boolean daset = sharedPreferences.getBoolean("daset",false);
//        if(!daset){
//            AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
//
//            Intent intent = new Intent(context, NotifiScheduleReceiver.class);
//            PendingIntent pendingIntent =
//                    PendingIntent.getBroadcast(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
//            Calendar calendar = Calendar.getInstance();
//
//            calendar.set(Calendar.SECOND,1);
//            calendar.set(Calendar.MINUTE,0);
//            calendar.set(Calendar.HOUR_OF_DAY,20);
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
//                alarmManager
//                        .setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(),AlarmManager.INTERVAL_DAY, pendingIntent);
////            alarmManager.setExact(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
//            } else {
//                alarmManager
//                        .setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(),AlarmManager.INTERVAL_DAY, pendingIntent);
////            alarmManager.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), pendingIntent);
//            }
//            sharedPreferences.edit().putBoolean("daset",true).apply();
//            //hiện tại đang đặt là 1 tiếng báo 1 lần :))
//            //bản chính thức sẽ sửa thành 1 ngày
//        }
//
//
//    }
//    public static void setAlarm(Context context,int hour,int min,String msg){
//        Intent it = new Intent(AlarmClock.ACTION_SET_ALARM)
//                .putExtra(AlarmClock.EXTRA_HOUR,hour)
//                .putExtra(AlarmClock.EXTRA_MINUTES, min)
//                .putExtra(AlarmClock.EXTRA_MESSAGE,msg)
//                .putExtra(AlarmClock.EXTRA_SKIP_UI, true);
//        context.startActivity(it);
//    }
//
//}
