package eagleteam.studentsocial.repository;

import android.app.Application;

import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import eagleteam.studentsocial.database.MarkDao;
import eagleteam.studentsocial.database.StudentSocialDatabase;
import eagleteam.studentsocial.models.Mark;


public class MarkRepository {
    private MarkDao markDao;
    public MarkRepository(Application application) {
        StudentSocialDatabase database = StudentSocialDatabase.getInstance(application);
        markDao = database.markDao();
    }

    public List<Mark> getListMarksByMaSV(String maSV) throws Exception {
        List<Mark> marks;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<List<Mark>> callable = () -> markDao.getListMarksByMaSV(maSV);
            Future<List<Mark>> future = executorService.submit(callable);
            marks = future.get();
            executorService.shutdown();
        } catch (InterruptedException e) {
            throw new InterruptedException(e.getMessage());
        } catch (ExecutionException e) {
            throw new Exception(e.getMessage());
        }
        return marks;
    }

    public boolean insertListMarks(List<Mark> listMarks) throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = () -> {
                try{
                    markDao.insertListMarks(listMarks);
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

    public boolean deleteListMarksByMaSV(String maSV) throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = new Callable<Boolean>() {
                @Override
                public Boolean call() throws Exception {
                    try{
                        markDao.deleteListMarksByMaSV(maSV);
                        return true;
                    }catch (Exception e){
                        throw new Exception(e.getMessage());
                    }
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

    public boolean deleteAllMarks() throws Exception {
        boolean success = false;
        try{
            ExecutorService executorService = Executors.newSingleThreadExecutor();
            Callable<Boolean> callable = new Callable<Boolean>() {
                @Override
                public Boolean call() throws Exception {
                    try{
                        markDao.deleteAllMarks();
                        return true;
                    }catch (Exception e){
                        throw new Exception(e.getMessage());
                    }
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
}
