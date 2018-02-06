//
//  MenuSelectedFood.swift
//  FoodIn
//
//  Created by Admin on 6/2/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
class MenuSelectedFood {
    
    // Singleton
    class var sharedInstance: MenuSelectedFood {
        struct Static {
            static let instance = MenuSelectedFood()
        }
        return Static.instance
    }
    
    var SelectedFood: Food?
}
