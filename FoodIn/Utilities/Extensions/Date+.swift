//
//  Date+.swift
//  FoodIn
//
//  Created by ryan on 12/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
}
