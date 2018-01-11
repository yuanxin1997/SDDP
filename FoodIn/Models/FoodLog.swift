//
//  FoodLog.swift
//  FoodIn
//
//  Created by ryan on 12/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit

import Foundation

struct FoodLog: Decodable {
    var id: Int
    var name: String
    var calories: Double
    var carbohydrate: Double
    var fat: Double
    var protein: Double
    var vitaminA: Double
    var vitaminC: Double
    var sodium: Double
    var potassium: Double
    var calcium: Double
    var iron: Double
}
