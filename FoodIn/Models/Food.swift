//
//  Food.swift
//  FoodIn
//
//  Created by Yuanxin Li on 30/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

struct Food: Decodable {
    let name: String
    let calories: Double
    let carbohydrate: Double
    let fat: Double
    let protein: Double
    let vitaminA: Double
    let vitaminC: Double
    let sodium: Double
    let potassium: Double
    let calcium: Double
    let iron: Double
}

/*
 Serializing and deserializing of/to JSON make it easier in Swift 4.
 Simply just define the protocol below:
 - Encodable
 - Decodable
 - Codable (Both)
 */

