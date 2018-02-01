//
//  LabelResults.swift
//  FoodIn
//
//  Created by Admin on 2/2/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
class LabelResults {
    
    // Singleton
    class var sharedInstance: LabelResults {
        struct Static {
            static let instance = LabelResults()
        }
        return Static.instance
    }
    
    var data: Dictionary<String, Double>?
}
