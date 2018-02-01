//
//  ExtractedAvoidArray.swift
//  FoodIn
//
//  Created by Admin on 1/2/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
class ExtractedAvoidArray {
    
    // Singleton
    class var sharedInstance: ExtractedAvoidArray {
        struct Static {
            static let instance = ExtractedAvoidArray()
        }
        return Static.instance
    }
    
    var objectArray: [Food]?
}
