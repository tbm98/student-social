package eagleteam.studentsocial.platform_channel

import android.app.Application
import android.content.Context
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import eagleteam.studentsocial.models.Mark
import eagleteam.studentsocial.models.Schedule
import eagleteam.studentsocial.models.User
import eagleteam.studentsocial.repository.MarkRepository
import eagleteam.studentsocial.repository.ScheduleRepository
import eagleteam.studentsocial.repository.UserRepository
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception

class HandlerDatabase(val application: Application) {
    private lateinit var userRepository: UserRepository
    private lateinit var markRepository: MarkRepository
    private lateinit var scheduleRepository: ScheduleRepository
    private val gson = Gson()


    init {
        userRepository = UserRepository(application)
        markRepository = MarkRepository(application)
        scheduleRepository = ScheduleRepository(application)
    }

    fun setProfile(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val data = methodCall.argument<String>("data")
            val profile = gson.fromJson(data, User::class.java)
            val oldProfile = userRepository.getUserByMaSV(profile.maSinhVien)
            if (oldProfile != null) {
                result.error("ERROR: mã sinh viên đã tồn tại trong database", null, null)
                return
            }
            userRepository.insertOnlyUser(profile)
            result.success("SUCCESS: lưu tài khoản thành công")
        } catch (e: Exception) {
            result.error("ERROR: lưu tài khoản bị lỗi", e.message, null)
        }
    }

    fun setMark(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val data = methodCall.argument<String>("data")
            val name = methodCall.argument<String>("name")
            val stc = methodCall.argument<String>("stc")
            val msv = methodCall.argument<String>("msv")
            val mapData = gson.fromJson<ArrayList<Mark>>(data, object : TypeToken<ArrayList<Mark>>() {}.type)
            val mapName = gson.fromJson(name, Map::class.java)
            val mapSTC = gson.fromJson(stc, Map::class.java)
            mapData.forEach { t: Mark? ->
                t?.setMoreDetail(msv, mapName[t.maMon].toString(), mapSTC[t.maMon].toString())
            }
//                        Log.i("mapData",mapData.toString())
//                        Log.i("mapName",mapName.toString())
//                        Log.i("mapSTC",mapSTC.toString())
            markRepository.insertListMarks(mapData)
            result.success("SUCCESS: lưu điểm thành công")
        } catch (e: Exception) {
            result.error("ERROR: lưu điểm bị lỗi", e.message, null)
        }
    }

    fun setSchedule(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val lichHoc = methodCall.argument<String>("lichhoc")
            val lichThi = methodCall.argument<String>("lichthi")
            val lichThiLai = methodCall.argument<String>("lichthilai")
            val msv = methodCall.argument<String>("msv")
            val tenMon = methodCall.argument<String>("tenmon")
            val mapLichHoc = gson.fromJson<ArrayList<Schedule>>(lichHoc, object : TypeToken<ArrayList<Schedule>>() {}.type)
            val mapLichThi = gson.fromJson<ArrayList<Schedule>>(lichThi, object : TypeToken<ArrayList<Schedule>>() {}.type)
            val mapLichThiLai = gson.fromJson<ArrayList<Schedule>>(lichThiLai, object : TypeToken<ArrayList<Schedule>>() {}.type)
            val mapTenMon = gson.fromJson(tenMon, Map::class.java)
            mapLichHoc.forEach { t: Schedule? -> t?.setMoreDetail(msv, mapTenMon[t.maMon].toString()) }
            mapLichThi.forEach { t: Schedule? -> t?.setMoreDetail(msv, mapTenMon[t.maMon].toString()) }
            mapLichThiLai.forEach { t: Schedule? -> t?.setMoreDetail(msv, mapTenMon[t.maMon].toString()) }
            //lọc những tiết bị trùng
            if (mapLichHoc != null && mapLichHoc.isNotEmpty())
                for (i in 0 until mapLichHoc.size - 1) {
                    var j = i + 1
                    while (j < mapLichHoc.size) {
                        if (mapLichHoc[j].equal(mapLichHoc[i])) {
                            mapLichHoc.removeAt(j)
                            j--
                        }
                        j++
                    }
                }
            //lọc những tiết bị trùng
            if (mapLichThi != null && mapLichThi.isNotEmpty())
                for (i in 0 until mapLichThi.size - 1) {
                    var j = i + 1
                    while (j < mapLichThi.size) {
                        if (mapLichThi[j].equal(mapLichThi[i])) {
                            mapLichThi.removeAt(j)
                            j--
                        }
                        j++
                    }
                }
            //lọc những tiết bị trùng
            if (mapLichThiLai != null && mapLichThiLai.isNotEmpty())
                for (i in 0 until mapLichThiLai.size - 1) {
                    var j = i + 1
                    while (j < mapLichThiLai.size) {
                        if (mapLichThiLai[j].equal(mapLichThiLai[i])) {
                            mapLichThiLai.removeAt(j)
                            j--
                        }
                        j++
                    }
                }
            scheduleRepository.run {
                insertListSchedules(mapLichHoc)
                insertListSchedules(mapLichThi)
                insertListSchedules(mapLichThiLai)
            }
            result.success("SUCCESS: lưu lịch thành công")
        } catch (e: Exception) {
            result.error("ERROR: lưu lịch bị lỗi", e.message, null)
        }
    }

    fun removeSchedule(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            scheduleRepository.run {
                deleteAllSchedules()
            }
            result.success("SUCCESS: xoá lịch thành công")
        } catch (e: Exception) {
            result.error("ERROR: xoá lịch bị lỗi", e.message, null)
        }
    }

    fun removeScheduleByMSV(methodCall: MethodCall, result: MethodChannel.Result) {
        val msv = methodCall.argument<String>("msv")
        val type = methodCall.argument<String>("type")
        try {
            scheduleRepository.run {
                if (type == null || type.isEmpty()) {
                    deleteScheduleByMSV(msv)
                } else {
                    deleteScheduleByMSVWithOutNote(msv)
                }
            }
            result.success("SUCCESS: xoá lịch $msv thành công")
        } catch (e: Exception) {
            result.error("ERROR: xoá lịch $msv bị lỗi", e.message, null)
        }
    }

    fun removeOneSchedule(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val data = methodCall.argument<String>("data")
            val schedule = gson.fromJson(data, Schedule::class.java)
            scheduleRepository.run {
                deleteOnlySchedule(schedule)
            }
            result.success("SUCCESS: xoá 1 lịch thành công")
        } catch (e: Exception) {
            result.error("ERROR: xoá 1 lịch bị lỗi", e.message, null)
        }
    }

    fun updateOneSchedule(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val data = methodCall.argument<String>("data")
            val schedule = gson.fromJson(data, Schedule::class.java)
            scheduleRepository.run {
                updateOnlySchedule(schedule)
            }
            result.success("SUCCESS: update 1 lịch thành công")
        } catch (e: Exception) {
            result.error("ERROR: update 1 lịch bị lỗi", e.message, null)
        }
    }

    fun getProfile(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val msv = methodCall.argument<String>("msv")
            val profile = userRepository.getUserByMaSV(msv)
            result.success(gson.toJson(profile))
        } catch (e: Exception) {
            result.error("ERROR: lấy tài khoản bị lỗi", e.message, null)
        }
    }

    fun getAllProfile(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val profile = userRepository.getAllUsers()
            result.success(gson.toJson(profile))
        } catch (e: Exception) {
            result.error("ERROR: lấy all tài khoản bị lỗi", e.message, null)
        }
    }

    fun getMark(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val msv = methodCall.argument<String>("msv")
            val valueFromDB = markRepository.getListMarksByMaSV(msv)
            val stringValue = gson.toJson(valueFromDB)
            result.success(stringValue)
        } catch (e: Exception) {
            result.error("ERROR: lấy điểm bị lỗi", e.message, null)
        }
    }

    fun removeMark(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            markRepository.run {
                deleteAllMarks()
            }
            result.success("SUCCESS: xoá điểm thành công")
        } catch (e: Exception) {
            result.error("ERROR: xoá điểm bị lỗi", e.message, null)
        }
    }

    fun removeMarkByMSV(methodCall: MethodCall, result: MethodChannel.Result) {
        val msv = methodCall.argument<String>("msv")
        try {
            markRepository.run {
                deleteListMarksByMaSV(msv)
            }
            result.success("SUCCESS: xoá điểm $msv thành công")
        } catch (e: Exception) {
            result.error("ERROR: xoá điểm $msv bị lỗi", e.message, null)
        }
    }

    fun getSchedule(methodCall: MethodCall, result: MethodChannel.Result) {
        val msv = methodCall.argument<String>("msv")
        try {
            val schedules = scheduleRepository.getListSchedules(msv)
            result.success(gson.toJson(schedules))
        } catch (e: Exception) {
            result.error("ERROR: lấy lịch bị lỗi", e.message, null)
        }
    }

    fun removeProfile(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            userRepository.run {
                deleteAllUser()
            }
            result.success("SUCCESS: xoá tài khoản thành công")
        } catch (e: Exception) {
            result.error("ERROR: xoá tài khoản bị lỗi", e.message, null)
        }
    }

    fun removeProfileByMSV(methodCall: MethodCall, result: MethodChannel.Result) {
        val msv = methodCall.argument<String>("msv")
        try {
            userRepository.run {
                deleteUserByMSV(msv)
            }
            result.success("SUCCESS: xoá tài khoản $msv thành công")
        } catch (e: Exception) {
            result.error("ERROR: xoá tài khoản $msv bị lỗi", e.message, null)
        }
    }

    fun saveCurrentMSV(methodCall: MethodCall, result: MethodChannel.Result) {
        val msv = methodCall.argument<String>("msv")
        try {
            val editor = application.getSharedPreferences(PlatformChannel.shared, Context.MODE_PRIVATE).edit()
            editor.putString(PlatformChannel.currentMSV, msv)
            editor.apply()
            result.success("SUCCESS: save $msv thành công")
        } catch (e: Exception) {
            result.error("ERROR: save $msv bị lỗi", e.message, null)
        }
    }

    fun loadCurrentMSV(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val prefs = application.getSharedPreferences(PlatformChannel.shared, Context.MODE_PRIVATE)
            val restoredText = prefs.getString(PlatformChannel.currentMSV, "guest")
            result.success(restoredText)
        } catch (e: Exception) {
            result.error("ERROR: load currentMSV bị lỗi", e.message, null)
        }
    }

    fun addNote(methodCall: MethodCall, result: MethodChannel.Result) {
        try {
            val noteData = methodCall.argument<String>("note")
            val note = gson.fromJson(noteData, Schedule::class.java)

            scheduleRepository.run {
                insertOnlySchedule(note)
            }
            result.success("SUCCESS: add note thành công")
        } catch (e: Exception) {
            result.error("ERROR: add note bị lỗi", e.message, null)
        }
    }

    fun initMethodChannel(methodCall: MethodCall, result: MethodChannel.Result) {
        when (methodCall.method) {
            PlatformChannel.setProfile -> {
                setProfile(methodCall, result)
            }
            PlatformChannel.getProfile -> {
                getProfile(methodCall, result)
            }
            PlatformChannel.getAllProfile -> {
                getAllProfile(methodCall, result)
            }
            PlatformChannel.removeProfile -> {
                removeProfile(methodCall, result)
            }
            PlatformChannel.removeProfileByMSV -> {
                removeProfileByMSV(methodCall, result)
            }
            PlatformChannel.setMark -> {
                setMark(methodCall, result)
            }
            PlatformChannel.removeMark -> {
                removeMark(methodCall, result)
            }
            PlatformChannel.removeMarkByMSV -> {
                removeMarkByMSV(methodCall, result)
            }
            PlatformChannel.getMark -> {
                getMark(methodCall, result)
            }
            PlatformChannel.setSchedule -> {
                setSchedule(methodCall, result)
            }
            PlatformChannel.removeScheduleByMSV -> {
                removeScheduleByMSV(methodCall, result)
            }
            PlatformChannel.removeSchedule -> {
                removeSchedule(methodCall, result)
            }
            PlatformChannel.removeOneSchedule -> {
                removeOneSchedule(methodCall, result)
            }
            PlatformChannel.updateOneSchedule -> {
                updateOneSchedule(methodCall, result)
            }
            PlatformChannel.getSchedule -> {
                getSchedule(methodCall, result)
            }
            PlatformChannel.addNote -> {
                addNote(methodCall, result)
            }
            PlatformChannel.setCurrentMSV -> {
                saveCurrentMSV(methodCall, result)
            }
            PlatformChannel.getCurrentMSV -> {
                loadCurrentMSV(methodCall, result)
            }
        }
    }
}