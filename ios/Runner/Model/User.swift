//
//  User.swift
//  Runner
//
//  Created by TBM on 6/17/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//
/*
 @PrimaryKey
 @NonNull
 private String MaSinhVien;
 private String HoTen;
 private String NienKhoa;
 private String Lop;
 private String Nganh;
 private String Truong;
 private String HeDaoTao;
 private String TongTC;
 private String STCTD;
 private String STCTLN;
 private String DTBC;
 private String DTBCQD;
 private String SoMonKhongDat;
 private String SoTCKhongDat;
 private String Token;
 */

import Foundation
import RealmSwift
class User:  Object ,Codable{
    @objc dynamic var MaSinhVien = ""
    @objc dynamic var HoTen = ""
    @objc dynamic var NienKhoa = ""
    @objc dynamic var Lop = ""
    @objc dynamic var Nganh = ""
    @objc dynamic var Truong = ""
    @objc dynamic var HeDaoTao = ""
    @objc dynamic var TongTC = ""
    @objc dynamic var STCTD = ""
    @objc dynamic var STCTLN = ""
    @objc dynamic var DTBC = ""
    @objc dynamic var DTBCQD = ""
    @objc dynamic var SoMonKhongDat = ""
    @objc dynamic var SoTCKhongDat = ""
    @objc dynamic var Token = ""
    override static func primaryKey() -> String? {
        return "MaSinhVien"
    }
}
