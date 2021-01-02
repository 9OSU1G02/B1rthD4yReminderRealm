//
//  Person.swift
//  BirthDayReminderRealm
//
//  Created by Nguyen Quoc Huy on 12/21/20.
//

import UIKit
import RealmSwift
class Person: Object {
    
    convenience init(name: String, birthday: Date, reminder: Bool, avatar: Data, phone: String = "", email: String = "", id: String = UUID().uuidString) {
        self.init()
        self.name = name
        self.birthday = birthday
        notification = reminder
        self.avatar = avatar
        self.phone = phone
        self.email = email
        self.dob = Calendar.current.dateComponents([.day], from: birthday).day!
        self.mob = Calendar.current.dateComponents([.month], from: birthday).month!
        self.id = id
    }
    
    @objc dynamic var phone = ""
    @objc dynamic var email = ""
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    @objc dynamic var birthday = Date()
    @objc dynamic var avatar = UIImage(systemName: "avatar")?.pngData()
    @objc dynamic var notification = true
    @objc dynamic var dob = 0
    @objc dynamic var mob = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    dynamic var age: Int {
        return Calendar.current.dateComponents([.year], from: birthday, to: Date()).year!
    }
    
    dynamic var monthName: String {
        return DateFormatter().monthSymbols[Int(mob) - 1]
    }
}
