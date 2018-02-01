
//
//  ExractedTextArray.swift
//  FoodIn
//
//  Created by Yuanxin Li on 25/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
class ExtractedSafeArray {
    
    // Singleton
    class var sharedInstance: ExtractedSafeArray {
        struct Static {
            static let instance = ExtractedSafeArray()
        }
        return Static.instance
    }
    
    var objectArray: [Food]?
}
