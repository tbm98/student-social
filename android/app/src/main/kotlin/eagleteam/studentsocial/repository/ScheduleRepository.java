package eagleteam.studentsocial.repository;

import android.app.Application;
import android.content.Context;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import eagleteam.studentsocial.database.ScheduleDao;
import eagleteam.studentsocial.database.StudentSocialDatabase;
import eagleteam.studentsocial.models.Schedule;

import static java.text.DateFormat.getDateInstance;

public class ScheduleRepository {
    private ScheduleDao scheduleDao;

    public ScheduleRepository(Application application){
        StudentSocialDatabase database = StudentSocialDatabase.getInstance(application);
        scheduleDao = database.scheduleDao();
    }
    public ScheduleRepository(Context context){
        StudentSocialDatabase database = StudentSocialDatabase.getInstance(context);
        scheduleDao = database.scheduleDao();
    }

    public List<Schedule> getListSchedules(String msv) throws Exception {
        List<Schedule> schedules;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<List<Schedule>> callable = () -> {
                try{
                    return scheduleDao.getAllSchedules(msv);
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<List<Schedule>> future = executorService.submit(callable);
            schedules = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return schedules;
    }

    public boolean insertListSchedules(List<Schedule> listSchedules) throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    scheduleDao.insertListSchedules(listSchedules);
                    return true;
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<Boolean> future = executorService.submit(callable);
            success = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return success;
    }

    public boolean insertOnlySchedule(Schedule schedule) throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    scheduleDao.insertOnlySchedule(schedule);
                    return true;
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<Boolean> future = executorService.submit(callable);
            success = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return success;
    }

    public boolean deleteOnlySchedule(Schedule schedule) throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    scheduleDao.deleteOnlySchedule(schedule);
                    return true;
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<Boolean> future = executorService.submit(callable);
            success = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return success;
    }

    public boolean deleteScheduleByMSV(String msv) throws Exception{
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    scheduleDao.deleteScheduleByMSV(msv);
                    return true;
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<Boolean> future = executorService.submit(callable);
            success = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return success;
    }
    public boolean deleteScheduleByMSVWithOutNote(String msv) throws Exception{
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    scheduleDao.deleteScheduleByMSVWithOutNote(msv);
                    return true;
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<Boolean> future = executorService.submit(callable);
            success = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return success;
    }

    public boolean deleteAllSchedules() throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    scheduleDao.deleteAllSchedules();
                    return true;
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<Boolean> future = executorService.submit(callable);
            success = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return success;
    }

    public boolean updateOnlySchedule(Schedule schedule) throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    scheduleDao.updateOnlySchedule(schedule);
                    return true;
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<Boolean> future = executorService.submit(callable);
            success = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return success;
    }

    public int countSchedules() throws Exception {
        int count;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Integer> callable = () -> {
                try{
                    return scheduleDao.countSchedules();
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<Integer> future = executorService.submit(callable);
            count = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return count;
    }

    public List<Schedule> getListScheduleByDateAndMSV(Date date, String msv) throws Exception {
        String strDate = new SimpleDateFormat("yyyy-MM-dd").format(date);
        List<Schedule> schedules;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<List<Schedule>> callable = () -> {
                try{
                    return scheduleDao.getAllSchedulesFromDate(msv,strDate);
                }catch (Exception e){
                    throw new Exception(e.getMessage());
                }
            };
            Future<List<Schedule>> future = executorService.submit(callable);
            schedules = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return schedules;

    }
}
