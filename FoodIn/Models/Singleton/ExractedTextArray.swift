//
//  ExractedTextArray.swift
//  FoodIn
//
//  Created by Yuanxin Li on 25/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
class ExtractedTextArray {
    
    // Singleton
    class var sharedInstance: ExtractedTextArray {
        struct Static {
            static let instance = ExtractedTextArray()
        }
        return Static.instance
    }
    
    var objectArray: [Food]?
}
