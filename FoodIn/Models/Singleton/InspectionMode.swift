//
//  InspectionMode.swift
//  FoodIn
//
//  Created by Yuanxin Li on 9/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
class InspectionMode {
    
    // Singleton
    class var sharedInstance: InspectionMode {
        struct Static {
            static let instance = InspectionMode()
        }
        return Static.instance
    }
    
    var mode: String?
}

