//
//  Mark.swift
//  Runner
//
//  Created by TBM on 6/17/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//
/*
 private int ID;
 private String MaSinhVien;
 private String MaMon;
 private String TenMon;
 private String SoTinChi;
 private String CC;
 private String KT;
 private String THI;
 private String TKHP;
 private String DiemChu;
 */

import Foundation
import RealmSwift
class Mark:  Object ,Codable{
    //những biến có dấu ? là những biến ko bắt buộc khi decode json phải có, có thể gán nó sau khi deocde
    @objc dynamic var ID:String? = ""
    @objc dynamic var MaSinhVien:String? = ""
    @objc dynamic var MaMon = ""
    @objc dynamic var TenMon:String? = ""
    @objc dynamic var SoTinChi:String? = ""
    @objc dynamic var CC = ""
    @objc dynamic var KT = 0.0
    @objc dynamic var THI = ""
    @objc dynamic var TKHP = ""
    @objc dynamic var DiemChu = ""
    override static func primaryKey() -> String? {
        return "ID"
    }
}
