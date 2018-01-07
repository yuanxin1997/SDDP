//
//  Registration.swift
//  FoodIn
//
//  Created by Yuanxin Li on 6/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

class Registration {
    // singleton
     class var sharedInstance: Registration {
        struct Static {
            static let instance = Registration()
        }
        return Static.instance
    }
    
    var name: String?
    var gender: String?
    var dob: String?
    var weight: Double?
    var height: Double?
    var email: String?
    var password: String?
    var illness: [Illness]?
    
    func clear() {
        print("clear")
        name = nil
        gender = nil
        dob = nil
        weight = nil
        height = nil
        email = nil
        password = nil
        illness = nil
    }
    func view() {
        print("view")
        print(name)
        print(gender)
        print(dob)
        print(weight)
        print(height)
        print(email)
        print(password)
        print(illness)
    }
}
