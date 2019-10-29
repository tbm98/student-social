//package eagleteam.studentsocial.schedule_notifi_daily;
//
//import android.app.Notification;
//import android.app.NotificationChannel;
//import android.app.NotificationManager;
//import android.app.PendingIntent;
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.content.SharedPreferences;
//import android.graphics.BitmapFactory;
//import android.os.Build;
//import android.provider.Settings;
//import android.util.Log;
//
//import androidx.core.app.NotificationCompat;
//
//import java.text.SimpleDateFormat;
//import java.util.ArrayList;
//import java.util.Collections;
//import java.util.Comparator;
//import java.util.Date;
//import java.util.List;
//import java.util.Random;
//
//import eagleteam.studentsocial.MainActivity;
//import eagleteam.studentsocial.R;
//import eagleteam.studentsocial.models.Schedule;
//import eagleteam.studentsocial.repository.ScheduleRepository;
//
//import static eagleteam.studentsocial.platform_channel.PlatformChannel.currentMSV;
//import static eagleteam.studentsocial.platform_channel.PlatformChannel.shared;
//
//public class NotifiScheduleReceiver extends BroadcastReceiver {
//    private static final int TIME_VIBRATE = 1000; // rung trong vòng 1s
//    ScheduleRepository scheduleRepository;
//    List<Schedule> schedules = new ArrayList<>();
//    String msv = "";
//    String contentText = "";
//    SharedPreferences sharedPreferences;
//
//
//    private void createNotificationChannel(Context context) {
//        // Create the NotificationChannel, but only on API 26+ because
//        // the NotificationChannel class is new and not in the support library
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            String name = "Student Social";
//            String description = "Lịch cá nhân";
//            int importance = NotificationManager.IMPORTANCE_HIGH;
//            NotificationChannel channel = new NotificationChannel("id_studentsocial_channel", name, importance);
//            channel.setDescription(description);
//            // Register the channel with the system; you can't change the importance
//            // or other notification behaviors after this
//            NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//
//            mNotificationManager.createNotificationChannel(channel);
//        }
//    }
//
//    public class CustomComparator implements Comparator<Schedule> {
//        @Override
//        public int compare(Schedule o1, Schedule o2) {
//            return o2.getThoiGian().compareTo(o1.getThoiGian());
//        }
//    }
//
//    private void initDatabase(Context context) {
//        scheduleRepository = new ScheduleRepository(context);
//        sharedPreferences = context.getSharedPreferences(shared, Context.MODE_PRIVATE);
//        msv = sharedPreferences.getString(currentMSV, "guest");
//        Date date = new Date(System.currentTimeMillis() + 86400000);// lay ngay hien tai cong them 1 ngay => ngay mai
//        try {
//            this.schedules = scheduleRepository.getListScheduleByDateAndMSV(date, msv);
//        } catch (Exception e) {
//            Log.i("getListScheduleByDate", e.getMessage());
//        }
//        Collections.sort(schedules, new CustomComparator());
//    }
//
//    String getContentRandomWhenFree() {
//        String[] free = {"Ngày mai bạn rảnh ^_^", "Ngày mai không có lịch, nhưng cũng đừng dậy muộn quá nhé :D", "Mai được nghỉ rồi ^_^"};
//        int index = new Random().nextInt(free.length);
//        return free[index];
//    }
//
//    String getContentTitle() {
//        Date date = new Date(System.currentTimeMillis() + 86400000);// lay ngay hien tai cong them 1 ngay => ngay mai
//        String strDate = new SimpleDateFormat("dd-MM-yyyy").format(date);
//        return "Lịch cá nhân - ngày mai " + strDate;
//    }
//
//    int getSecondForID() {
//        return (int) (System.currentTimeMillis() % 86400000); //sẽ ra số giây hiên tại trong ngày hôm nay
//    }
//
//    @Override
//    public void onReceive(Context context, Intent intent) {
//        createNotificationChannel(context);
//        initDatabase(context);
//        if (schedules.isEmpty()) {
//            this.contentText = getContentRandomWhenFree();
//            Intent notificationIntent = new Intent(context, MainActivity.class);
//            notificationIntent
//                    .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
//            int requestID = (int) System.currentTimeMillis();
//            PendingIntent contentIntent = PendingIntent
//                    .getActivity(context, requestID, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
//            NotificationCompat.Builder builder =
//                    new NotificationCompat.Builder(context, "id_studentsocial_channel")
//                            .setSmallIcon(R.mipmap.ic_logo)
//                            .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_logo))
//                            .setContentTitle(getContentTitle())
//                            .setContentText(contentText)
//                            .setSound(Settings.System.DEFAULT_NOTIFICATION_URI)
//                            .setDefaults(Notification.DEFAULT_ALL)
//                            .setAutoCancel(false)
//                            .setPriority(NotificationCompat.PRIORITY_MAX)
//                            .setVibrate(new long[]{TIME_VIBRATE, TIME_VIBRATE, TIME_VIBRATE, TIME_VIBRATE,
//                                    TIME_VIBRATE})
//                            .setStyle(new NotificationCompat.BigTextStyle().bigText(contentText))
//                            .setContentIntent(contentIntent);
//            NotificationManager notificationManager =
//                    (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//            notificationManager.notify(getSecondForID(), builder.build());
//        } else {
//            for (int i = 0; i < this.schedules.size(); i++) {
//                Schedule schedule = this.schedules.get(i);
//                contentText = "";
//                if (schedule.getLoaiLich().equals("LichHoc")) {
//                    contentText += "Môn học: " + schedule.getTenMon();
//                    contentText += "\nThời gian: " + schedule.getThoiGian();
//                    contentText += "\nĐịa điểm: " + schedule.getDiaDiem();
//                    contentText += "\nGiáo viên: " + schedule.getGiaoVien();
//                }
//                if (schedule.getLoaiLich().equals("LichThi")) {
//                    contentText += "Môn thi: " + schedule.getTenMon();
//                    contentText += "\nSBD: " + schedule.getSoBaoDanh();
//                    contentText += "\nThời gian: " + schedule.getThoiGian();
//                    contentText += "\nĐịa điểm: " + schedule.getDiaDiem();
//                    contentText += "\nHình thức: " + schedule.getHinhThuc();
//                }
//                if (schedule.getLoaiLich().equals("Note")) {
//                    contentText += "Tiêu đề: " + schedule.getMaMon();
//                    contentText += "\nNội dung: " + schedule.getTenMon();
//                }
//                //push
//                Intent notificationIntent = new Intent(context, MainActivity.class);
//                notificationIntent
//                        .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
//                int requestID = (int) System.currentTimeMillis();
//                PendingIntent contentIntent = PendingIntent
//                        .getActivity(context, requestID, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);
//                NotificationCompat.Builder builder =
//                        new NotificationCompat.Builder(context, "id_studentsocial_channel")
//                                .setSmallIcon(R.mipmap.ic_logo)
//                                .setLargeIcon(BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_logo))
//                                .setContentTitle(getContentTitle())
//                                .setContentText(contentText)
//                                .setSound(Settings.System.DEFAULT_NOTIFICATION_URI)
//                                .setDefaults(Notification.DEFAULT_ALL)
//                                .setAutoCancel(false)
//                                .setPriority(NotificationCompat.PRIORITY_MAX)
//                                .setVibrate(new long[]{TIME_VIBRATE, TIME_VIBRATE, TIME_VIBRATE, TIME_VIBRATE,
//                                        TIME_VIBRATE})
//                                .setStyle(new NotificationCompat.BigTextStyle().bigText(contentText))
//                                .setContentIntent(contentIntent);
//                NotificationManager notificationManager =
//                        (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//                notificationManager.notify(getSecondForID(), builder.build());
//            }
//        }
//    }
//}
