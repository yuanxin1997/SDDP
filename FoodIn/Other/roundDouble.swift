//
//  roundDouble.swift
//  FoodIn
//
//  Created by Yuanxin Li on 30/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

extension Double {
    
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
