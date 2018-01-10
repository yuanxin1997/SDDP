//
//  Registration.swift
//  FoodIn
//
//  Created by Yuanxin Li on 6/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

class Registration {
    
    // Singleton
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
    
    // Reset all data in singleton
    func clear() {
        name = nil
        gender = nil
        dob = nil
        weight = nil
        height = nil
        email = nil
        password = nil
        illness = nil
    }
    
}
