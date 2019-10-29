//
//  Schedule.swift
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
 private String ThoiGian;
 private String Ngay;
 private String DiaDiem;
 private String HinhThuc;
 private String GiaoVien;
 private String LoaiLich;
 private String SoBaoDanh;
 private String SoTinChi;
 */

import Foundation
import RealmSwift
class Schedule:  Object ,Codable{
    //những biến có dấu ? là những biến ko bắt buộc khi decode json phải có, có thể gán nó sau khi deocde
    @objc dynamic var ID:String? = ""
    @objc dynamic var MaSinhVien:String? = ""
    @objc dynamic var MaMon:String? = ""
    @objc dynamic var TenMon:String? = ""
    @objc dynamic var ThoiGian:String? = ""
    @objc dynamic var Ngay:String? = ""
    @objc dynamic var DiaDiem:String? = ""
    @objc dynamic var HinhThuc:String? = ""
    @objc dynamic var GiaoVien:String? = ""
    @objc dynamic var LoaiLich:String? = ""
    @objc dynamic var SoBaoDanh:String? = ""
    @objc dynamic var SoTinChi:String? = ""
    override static func primaryKey() -> String? {
        return "ID"
    }
}
