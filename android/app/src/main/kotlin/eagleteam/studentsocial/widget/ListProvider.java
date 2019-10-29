package eagleteam.studentsocial.widget;

import android.app.Application;
import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import eagleteam.studentsocial.R;
import eagleteam.studentsocial.models.Schedule;
import eagleteam.studentsocial.repository.ScheduleRepository;

import static eagleteam.studentsocial.platform_channel.PlatformChannel.currentMSV;
import static eagleteam.studentsocial.platform_channel.PlatformChannel.shared;


class Sortbyroll implements Comparator<Schedule> {
    // Used for sorting in ascending order of
    // roll number
    public int compare(Schedule a, Schedule b) {
        return a.getThoiGian().compareTo(b.getThoiGian());
    }
}

public class ListProvider implements RemoteViewsService.RemoteViewsFactory {

    private Context context;
    private List<Schedule> schedules;
    private int appWidgetId;
    private ScheduleRepository scheduleRepository;

    public ListProvider(Context context, Intent intent, Application application) {
        this.context = context;
        appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID,
                AppWidgetManager.INVALID_APPWIDGET_ID);
        scheduleRepository = new ScheduleRepository(application);
        dataChanged();
    }

    private void dataChanged() {
        //load currentMSV
        SharedPreferences prefs = context.getSharedPreferences(shared, Context.MODE_PRIVATE);
        String msv = prefs.getString(currentMSV, "");
        if (msv.isEmpty()) {
            return;
        }

        try {
            schedules = scheduleRepository.getListSchedules(msv);
        } catch (Exception e) {
            Log.i("ERROR_when_get_schedule", e.getMessage());
            return;
        }
        if (schedules.isEmpty()) {
            return;
        }
        populateListItem();
    }

    private void populateListItem() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DATE, NewAppWidget.delta);
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
        String dateS = format.format(calendar.getTime());
        Log.e("KEY", dateS);
        List<Schedule> temp = new ArrayList<>();
        for (Schedule schedule : schedules) {
            if (schedule.getNgay().equals(dateS)){
                temp.add(schedule);
            }
        }
        schedules.clear();
        schedules.addAll(temp);
        Collections.sort(schedules, new Sortbyroll());
    }


    @Override
    public void onCreate() {

    }

    @Override
    public void onDataSetChanged() {
        Log.e("DATA CHANGED", "ondatachanged");
        dataChanged();
    }

    @Override
    public void onDestroy() {

    }

    @Override
    public int getCount() {
        return schedules != null ? schedules.size() : 0;
    }

    private int getMua() {
        /*
         * return 1 neu la mua he
         * return 2 neu la mua dong
         * mua he bat dau tu 15/4
         * mua dong bat dau tu 15/10
         */
        int m = Calendar.getInstance().get(Calendar.MONTH) + 1;
        int d = Calendar.getInstance().get(Calendar.DAY_OF_MONTH);
        if (m == 1 || m == 2 || m == 3 || m == 11 || m == 12) {
            return 2;
        }
        if (m == 4) {
            if (d >= 15) {
                return 1;
            } else {
                return 2;
            }
        }
        if (m == 10) {
            if (d >= 15) {
                return 2;
            } else {
                return 1;
            }
        }
        return 1;
    }

    private String getThoiGian(String thoiGian) {
        String[] Time1 = {"06:30-07:20", "07:25-08:15",
                "08:25-09:15", "09:25-10:15", "10:20-11:10",
                "13:00-13:50", "13:55-14:45", "14:55-15:45",
                "15:55-16:45", "16:50-17:40", "18:15-19:05",
                "19:10-20:00"};
        String[] Time2 = {"06:45-07:35", "07:40-08:30",
                "08:40-09:30", "09:40-10:30", "10:35-11:25",
                "13:00-13:50", "13:55-14:45", "14:55-15:45",
                "15:55-16:45", "16:50-17:40", "18:15-19:05",
                "19:10-20:00"};
        int mua = getMua();
        if (thoiGian.contains(",")) {
            //co nhieu hon 1 tiet
            String[] tiets = thoiGian.split(",");
            int first = Integer.parseInt(tiets[0]);
            int last = Integer.parseInt(tiets[tiets.length - 1]);

            if (mua == 1) {
                //mua he lay lich Time1
                return "(" + Time1[first - 1].split("-")[0] + " - " + Time1[last - 1].split("-")[1] + ")";
            } else {
                return "(" + Time2[first - 1].split("-")[0] + " - " + Time2[last - 1].split("-")[1] + ")";
            }
        } else {
            //chi co 1 tiet :v
            int tiet = Integer.parseInt(thoiGian);
            if (mua == 1) {
                //mua he lay lich Time1
                return "(" + Time1[tiet - 1].split("-")[0] + " - " + Time1[tiet - 1].split("-")[1] + ")";
            } else {
                return "(" + Time2[tiet - 1].split("-")[0] + " - " + Time2[tiet - 1].split("-")[1] + ")";
            }
        }
    }

    @Override
    public RemoteViews getViewAt(int position) {
        final RemoteViews remoteView = new RemoteViews(
                context.getPackageName(), R.layout.layout_item_widget);
        Schedule schedule = schedules.get(position);
        switch (schedule.getLoaiLich()) {
            case "Note":
                remoteView.setTextViewText(R.id.tvMonHoc, "Tiêu đề: " + schedule.getMaMon());
                remoteView.setTextColor(R.id.tvMonHoc, Color.parseColor("#9c27b0"));
                remoteView.setTextViewText(R.id.tvThoiGian, "Nội dung: " + schedule.getThoiGian());
                remoteView.setViewVisibility(R.id.tvDiaDiem, View.GONE);
                remoteView.setViewVisibility(R.id.tvGiaoVien, View.GONE);
                remoteView.setViewVisibility(R.id.tvHinhThuc, View.GONE);
                break;
            case "LichHoc":
                remoteView.setTextViewText(R.id.tvMonHoc, "Môn: " + schedule.getTenMon());
                remoteView.setTextColor(R.id.tvMonHoc, Color.parseColor("#2196f3"));
                remoteView.setTextViewText(R.id.tvThoiGian, "Thời gian: " + schedule.getThoiGian() + " " + getThoiGian(schedule.getThoiGian()));
                remoteView.setTextViewText(R.id.tvDiaDiem, "Địa điểm: " + schedule.getDiaDiem());
                remoteView.setTextViewText(R.id.tvGiaoVien, "Giảng viên: " + schedule.getGiaoVien());
                remoteView.setViewVisibility(R.id.tvHinhThuc, View.GONE);
                break;
            case "LichThi":
                remoteView.setTextViewText(R.id.tvMonHoc, "Môn thi: " + schedule.getTenMon());
                remoteView.setTextColor(R.id.tvMonHoc, Color.parseColor("#f44336"));
                remoteView.setTextViewText(R.id.tvThoiGian, "Số báo danh: " + schedule.getSoBaoDanh());
                remoteView.setTextViewText(R.id.tvDiaDiem, "Thời gian: " + schedule.getThoiGian());
                remoteView.setTextViewText(R.id.tvGiaoVien, "Địa điểm: " + schedule.getDiaDiem());
                remoteView.setTextViewText(R.id.tvHinhThuc, "Hình thức: " + schedule.getHinhThuc());
                break;
        }

        return remoteView;
    }

    @Override
    public RemoteViews getLoadingView() {
        return null;
    }

    @Override
    public int getViewTypeCount() {
        return 1;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public boolean hasStableIds() {
        return true;
    }
}
