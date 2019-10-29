package eagleteam.studentsocial.repository;

import android.app.Application;
import android.os.AsyncTask;
import android.util.Log;


import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import eagleteam.studentsocial.database.StudentSocialDatabase;
import eagleteam.studentsocial.database.UserDao;
import eagleteam.studentsocial.models.User;

public class UserRepository {
    private UserDao userDao;

    public UserRepository(Application application) {
        StudentSocialDatabase database = StudentSocialDatabase.getInstance(application.getApplicationContext());
        userDao = database.userDao();
    }

    public boolean insertOnlyUser(User user) throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    userDao.insertOnlyUser(user);
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

    public boolean deleteAllUser() throws Exception{
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    userDao.deleteAllUser();
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

    public boolean deleteUserByMSV(String msv) throws Exception{
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    userDao.deleteUserByMSV(msv);
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

    public boolean updateOnlyUser(User user) throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    userDao.updateOnlyUser(user);
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

    public User getUserByMaSV(final String maSV) {
        try {
            ExecutorService executor = Executors.newSingleThreadExecutor();
            Callable<User> callable = () -> userDao.getUserByMaSinhVien(maSV);
            Future<User> future = executor.submit(callable);
            executor.shutdown();
            return future.get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<User> getAllUsers() {
        try {
            ExecutorService executor = Executors.newSingleThreadExecutor();
            Callable<List<User>> callable = () -> userDao.getAllUsers();
            Future<List<User>> future = executor.submit(callable);
            executor.shutdown();
            return future.get();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }
}
