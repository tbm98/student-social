//
//  PlatformChannel.swift
//  Runner
//
//  Created by TBM on 6/17/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

import Foundation
class PlatformChannel{
    static let database = "eagleteam.studentsocial/database";
    static let shared = "eagleteam.studentsocial/shared";
    static let currentMSV = "currentMSV";
    
    static let removeOneSchedule = "removeOneSchedule"; //cái này chỉ dành cho việc xoá ghi chú
    static let updateOneSchedule = "updateOneSchedule"; //same
    static let setSchedule = "setSchedule"
    static let getSchedule = "getSchedule";
    static let removeSchedule = "removeSchedule";
    static let removeScheduleByMSV = "removeScheduleByMSV";

    
    static let setLichHoc = "setlichhoc";
    static let getLichHoc = "getlichhoc";
    static let removeLichHoc = "removelichhoc";
    
    static let setLichThi = "setlichthi";
    static let getLichThi = "getlichthi";
    static let removeLichThi = "removelichthi";
    
    static let setLichThiLai = "setlichthilai";
    static let getLichThiLai = "getlichthilai";
    static let removeLichThiLai = "removelichthilai";
    
    static let setMark = "setMark";
    static let getMark = "getMark";
    static let removeMark = "removeMark";
    static let removeMarkByMSV = "removeMarkByMSV";

    
    static let setProfile = "setProfile";
    static let getProfile = "getProfile";
    static let removeProfile = "removeProfile";
    static let removeProfileByMSV = "removeProfileByMSV";
    static let getAllProfile = "getAllProfile";
    
    static let setCurrentMSV = "setCurrentMSV";
    static let getCurrentMSV = "getCurrentMSV";
    
    static let addNote = "addNote";

}
