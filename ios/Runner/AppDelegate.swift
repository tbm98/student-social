import UIKit
import Flutter
import RealmSwift

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    lazy var database:Realm = {
        return try! Realm()
    }()
    var jsonEncoder:JSONEncoder!
    var jsonDecoder:JSONDecoder!
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    let config = Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        //Mỗi lần thay đổi bất kì model nào đều phải tăng schemaVersion để không bị lỗi
        schemaVersion: 4,
        
        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        migrationBlock: { migration, oldSchemaVersion in
            // We haven’t migrated anything yet, so oldSchemaVersion == 0
            if (oldSchemaVersion < 1) {
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
            }
    })
    
    // Tell Realm to use this new configuration object for the default Realm
    Realm.Configuration.defaultConfiguration = config
    
    // Now that we've told Realm how to handle the schema change, opening the file
    // will automatically perform the migration
    jsonEncoder = JSONEncoder()
    jsonDecoder = JSONDecoder()
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    //init methodChannel
    initMethodChannel(controller: controller)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func initMethodChannel(controller:FlutterViewController){
        FlutterMethodChannel(name: PlatformChannel.database, binaryMessenger: controller.binaryMessenger)
            .setMethodCallHandler({
                (call: FlutterMethodCall, result: FlutterResult) -> Void in
                switch call.method {
                case PlatformChannel.setProfile:
                    self.setProfile(call: call,result: result)
                case PlatformChannel.setMark:
                    self.setMark(call: call,result: result)
                case PlatformChannel.setSchedule:
                    self.setSchedule(call: call,result: result)
                case PlatformChannel.removeOneSchedule:
                    self.removeOneSchedule(call: call, result: result)
                case PlatformChannel.updateOneSchedule:
                    self.updateOneSchedule(call: call, result: result)
                case PlatformChannel.getProfile:
                    self.getProfile(call: call,result: result)
                case PlatformChannel.getMark:
                    self.getMark(call: call,result: result)
                case PlatformChannel.getSchedule:
                    self.getSchedule(call: call,result: result)
                case PlatformChannel.removeSchedule:
                    self.removeSchedule(call: call,result: result)
                case PlatformChannel.removeScheduleByMSV:
                    self.removeScheduleByMSV(call: call,result: result)
                case PlatformChannel.removeMark:
                    self.removeMark(call: call,result: result)
                case PlatformChannel.removeMarkByMSV:
                    self.removeMarkByMSV(call: call,result: result)
                case PlatformChannel.removeProfile:
                    self.removeProfile(call: call,result: result)
                case PlatformChannel.removeProfileByMSV:
                    self.removeProfileByMSV(call: call,result: result)
                case PlatformChannel.setCurrentMSV:
                    self.saveCurrentMSV(call: call,result: result)
                case PlatformChannel.getCurrentMSV:
                    self.loadCurrentMSV(call: call,result: result)
                case PlatformChannel.getAllProfile:
                    self.getAllProfile(call: call,result: result)
                case PlatformChannel.addNote:
                    self.addNote(call: call,result: result)
                default:
                    result(FlutterMethodNotImplemented)
                }
            })
    }
    
    func removeSchedule(call: FlutterMethodCall,result:FlutterResult){
        do {
            let schedules = database.objects(Schedule.self)
            try database.write{
                database.delete(schedules)
            }
        } catch {
            result("ERROR: xoá lịch bị lỗi \(error)")
            return
        }
        result("SUCCESS: xoá lịch thành công")
    }
    
    func removeScheduleByMSV(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let msv:String = args["msv"] as! String
        let type:String? = args["type"] as? String ?? ""
        print("type is '\(type)'")
        do {
            if(type == nil || type?.isEmpty ?? true){
                let schedules = getScheduleFromDB(msv: msv)
                try database.write{
                    database.delete(schedules)
                }
            }else{
                let schedules = database.objects(Schedule.self).filter("MaSinhVien = '\(msv)' AND LoaiLich != 'Note'")
                try database.write{
                    database.delete(schedules)
                }
            }
            
        } catch {
            result("ERROR: xoá lịch \(msv) bị lỗi do \(error)")
            return
        }
        result("SUCCESS: xoá lịch \(msv) thành công")
    }
    
    func removeMark(call: FlutterMethodCall,result:FlutterResult){
        do {
            let marks = database.objects(Mark.self)
                try database.write{
                database.delete(marks)
            }
        } catch {
            result("ERROR: xoá điểm bị lỗi do \(error)")
            return
        }
        result("SUCCESS: xoá điểm thành công")
    }
    
    func removeMarkByMSV(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let msv:String = args["msv"] as! String
        do {
            
            let marks = getMarkFromDB(msv: msv)
            try database.write{
                database.delete(marks)
            }
        } catch {
            result("ERROR: xoá điểm \(msv) bị lỗi do \(error)")
            return
        }
        result("SUCCESS: xoá điểm \(msv) thành công")
    }
    
    func removeProfile(call: FlutterMethodCall,result:FlutterResult){
        do {
            let profiles = database.objects(User.self)
            try database.write{
                database.delete(profiles)
            }
        } catch {
            result("ERROR: xoá tài khoản bị lỗi do \(error)")
            return
        }
        result("SUCCESS: xoá tài khoản thành công")
    }
    
    func removeProfileByMSV(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let msv:String = args["msv"] as! String
        do {
            let profiles = getProfileFromDB(msv: msv)
            try database.write{
                database.delete(profiles)
            }
        } catch {
            result("ERROR: xoá tài khoản \(msv) bị lỗi do \(error)")
            return
        }
        result("SUCCESS: xoá tài khoản \(msv) thành công")
    }
    
    func setProfile(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        do {
            let data:String = args["data"] as! String
            let value = try getProfileFromString(data: data)
            try setProfileToDB(profile: value)
            result("SUCCESS: lưu tài khoản thành công")
        } catch let error{
            result("ERROR: lưu tài khoản bị lỗi do \(error)")
        }
        
    }
    
    func setMark(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let data:String = args["data"] as! String
        let name:String = args["name"] as! String
        let stc:String = args["stc"] as! String
        let msv:String = args["msv"] as! String
        var listMark:[Mark]
        var listName:[String:String]
        var listSTC:[String:String]
        
        do {
            listMark = try getListMarkFromString(data: data)
            listName = try getMapFromString(data: name)
            listSTC = try getMapFromString(data: stc)
        } catch {
            result("ERROR: lưu điểm bị lỗi do \(error)")
            return
        }
        
        listMark.forEach { (mark) in
            mark.ID = NSUUID().uuidString
            mark.MaSinhVien = msv
            mark.TenMon = listName[mark.MaMon]!
            mark.SoTinChi = listSTC[mark.MaMon]!
        }
        do {
            try setListMarkToDB(listMark: listMark)
        } catch {
            result("ERROR: lưu điểm bị lỗi do \(error)")
            return
        }
        result("SUCCESS: lưu điểm thành công")
    }
    
    func setSchedule(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let lichHoc:String = args["lichhoc"] as! String
        let lichThi:String = args["lichthi"] as! String
        let lichThiLai:String = args["lichthilai"] as! String
        let msv:String = args["msv"] as! String
        let tenMon:String = args["tenmon"] as! String
        var listLichHoc:[Schedule]
        var listLichThi:[Schedule]
        var listLichThiLai:[Schedule]
        do {
            listLichHoc = try getListScheduleFromString(data: lichHoc)
            listLichThi = try getListScheduleFromString(data: lichThi)
            listLichThiLai = try getListScheduleFromString(data: lichThiLai)
        } catch {
            result("ERROR: lưu lịch bị lỗi do \(error)")
            return
        }
        var listTenMon:[String:String]
        do {
            listTenMon = try getMapFromString(data: tenMon)
        } catch {
            result("ERROR: lấy tên môn học bị lỗi do \(error)")
            return
        }
        listLichHoc.forEach { (schedule) in
            schedule.ID = NSUUID().uuidString
            schedule.MaSinhVien = msv
            schedule.TenMon = listTenMon[schedule.MaMon!]!
        }
        listLichThi.forEach { (schedule) in
            schedule.ID = NSUUID().uuidString
            schedule.MaSinhVien = msv
            schedule.TenMon = listTenMon[schedule.MaMon!]!
        }
        listLichThiLai.forEach { (schedule) in
            schedule.ID = NSUUID().uuidString
            schedule.MaSinhVien = msv
            schedule.TenMon = listTenMon[schedule.MaMon!]!
        }

        do {
            try setListScheduleToDB(listSchedule: listLichHoc)
            try setListScheduleToDB(listSchedule: listLichThi)
            try setListScheduleToDB(listSchedule: listLichThiLai)
        } catch {
            result("ERROR: lưu lịch bị lỗi do \(error)")
            return
        }
        
        result("SUCCESS: lưu lịch thành công")
    }
    
    func removeOneSchedule(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let data:String = args["data"] as! String
        var schedule:Schedule
        do {
            schedule = try getScheduleFromString(data: data)
        } catch {
            result("ERROR: xoá 1 lịch bị lỗi do \(error)")
            return
        }
        do {
            try removeOneScheduleFromDB(schedule: schedule)
        } catch {
            result("ERROR: xoá 1 lịch bị lỗi do \(error)")
            return
        }
        result("SUCCESS: xoá 1 lịch thành công")
    }
    
    func updateOneSchedule(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let data:String = args["data"] as! String
        var schedule :Schedule
        do {
            schedule  = try getScheduleFromString(data: data)
        } catch {
            result("ERROR: update 1 lịch bị lỗi do \(error)")
            return
        }
        do {
            try updateOneScheduleToDB(schedule: schedule )
        } catch {
            result("ERROR: update 1 lịch bị lỗi do \(error)")
            return
        }
        result("SUCCESS: update 1 lịch thành công")
    }
    
    func getProfile(call: FlutterMethodCall,result: FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("ERROR: iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let msv:String = args["msv"] as! String
        let value = getProfileFromDB(msv: msv)
        do {
            try result(getStringByProfile(profile: value[0]))
        } catch {
            result("ERROR: lấy profile bị lỗi do \(error)")
        }
    }
    
    func getAllProfile(call: FlutterMethodCall,result: FlutterResult){
        let value = database.objects(User.self)
        do {
            try result(getStringByListProfile(listProfile: value))
        } catch {
            result("ERROR: lấy profile bị lỗi do \(error)")
        }
    }
    
    func addNote(call: FlutterMethodCall,result: FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let noteData:String = args["note"] as! String
        print("notedata is: \(noteData)")
        do {
            let note = try getScheduleFromString(data: noteData)
            note.ID = NSUUID().uuidString
            try setListScheduleToDB(listSchedule: [note])
            result("SUCCESS: add note thành công")
        } catch {
            result("ERROR: add note bị lỗi do \(error)")
        }
    }
    
    func getMark(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let msv:String = args["msv"] as! String
        let value = getMarkFromDB(msv: msv)
        do {
            try result(getStringByListMark(listMark: value))
        } catch {
            result("ERROR: lấy điểm \(msv) bị lỗi do \(error)")
        }
    }
    
    func getSchedule(call: FlutterMethodCall,result:FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let msv:String = args["msv"] as! String
        let value = getScheduleFromDB(msv: msv)
        do {
            try result(getStringByListSchedule(listSchedule: value))
        } catch {
            result("ERROR: lấy lịch bị lỗi do \(error)")
        }
    }
    
    func getStringByListMark(listMark:Results<Mark>) throws -> String{
        do {
            let jsonData = try jsonEncoder.encode(listMark.toArray(ofType: Mark.self))
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            return json!
        } catch let error{
            throw error
        }
    }
    
    func getStringByProfile(profile:User) throws -> String{
        do {
            let jsonData = try jsonEncoder.encode(profile)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            return json!
        } catch  let error{
            throw error
        }
    }
    
    func getStringByListProfile(listProfile:Results<User>) throws -> String{
        do {
            let jsonData = try jsonEncoder.encode(listProfile.toArray(ofType: User.self))
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            return json!
        } catch let error{
            throw error
        }
    }
    
    func getStringByListSchedule(listSchedule:Results<Schedule>) throws -> String{
        do {
            let jsonData = try jsonEncoder.encode(listSchedule.toArray(ofType: Schedule.self))
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            return json!
        } catch let error{
            throw error
        }
    }
    
    func getProfileFromString(data:String) throws -> User{
        do {
            let value = try jsonDecoder.decode(User.self, from: data.data(using: .utf8, allowLossyConversion: false)!)
            return value
        } catch let error{
            throw error
        }
    }
    
    func getListMarkFromString(data:String) throws-> [Mark]{
        do {
            let value = try jsonDecoder.decode([Mark].self, from: data.data(using: .utf8, allowLossyConversion: false)!)
            return value
        } catch let error{
            throw error
        }
        
    }
    
    func getListScheduleFromString(data:String) throws-> [Schedule]{
        do {
            let value = try jsonDecoder.decode([Schedule].self, from: data.data(using: .utf8, allowLossyConversion: false)!)
            return value
        } catch let error{
            throw error
        }
    }
    
    func getScheduleFromString(data:String) throws-> Schedule{
        do {
            let value = try jsonDecoder.decode(Schedule.self, from: data.data(using: .utf8, allowLossyConversion: false)!)
            return value
        } catch let error{
            throw error
        }
    }
    
    func getMapFromString(data:String) throws -> [String: String]{
        do {
            let value = try jsonDecoder.decode([String: String].self, from: data.data(using: .utf8, allowLossyConversion: false)!)
            return value
        } catch let error{
            throw error
        }
    }
    
    func updateOneScheduleToDB(schedule:Schedule) throws {
        do{
            try removeOneScheduleFromDB(schedule: schedule) //Xoá cái đó đi và thêm cái mới :))
            try database.write {
                database.add(schedule)
            }
        } catch let error{
            throw error
        }
    }
    
    func removeOneScheduleFromDB(schedule:Schedule) throws {
        do{
            try database.write {
                database.delete(database.objects(Schedule.self).filter("ID=%@",schedule.ID))
            }
        } catch let error{
            throw error
        }
    }
    
    func getProfileFromDB(msv:String) -> Results<User>{
        return database.objects(User.self).filter("MaSinhVien = '\(msv)'")
    }
    
    func getMarkFromDB(msv:String) -> Results<Mark>{
        return database.objects(Mark.self).filter("MaSinhVien = '\(msv)'")
    }
    
    func getScheduleFromDB(msv:String) -> Results<Schedule>{
        return database.objects(Schedule.self).filter("MaSinhVien = '\(msv)'")
    }
    
    func setProfileToDB(profile:User) throws {
        //check for primary key is exists
        let oldUser:Results = getProfileFromDB(msv: profile.MaSinhVien)
        if(!oldUser.isEmpty){
            throw "Mã sinh viên đã tồn tại"
        }
        do {
            try database.write({ // [2]
                database.add(profile)
            })
        } catch let error{
            throw error
        }
    }
    
    func setListMarkToDB(listMark:[Mark]) throws{
        do {
            try database.write({ // [2]
                database.add(listMark)
            })
        } catch let error{
            throw error
        }
    }
    
    func setListScheduleToDB(listSchedule:[Schedule]) throws{
        do {
            try database.write({ // [2]
                database.add(listSchedule)
            })
        } catch let error{
            throw error
        }
    }
    
    func saveCurrentMSV(call: FlutterMethodCall,result: FlutterResult){
        guard let args:[String: Any] = call.arguments as! [String : Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
        }
        let msv:String = args["msv"] as! String
        UserDefaults.standard.set(msv, forKey: PlatformChannel.currentMSV)
        result("SUCCESS: set current MSV thành công")
    }
    
    func loadCurrentMSV(call: FlutterMethodCall,result: FlutterResult){
        let msv = UserDefaults.standard.string(forKey: PlatformChannel.currentMSV) ?? "guest"

        result(msv)
    }
}
extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}
extension String: Error {}

