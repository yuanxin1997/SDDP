//
//  Person.swift
//  FoodIn
//
//  Created by Yuanxin Li on 18/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

struct Person: Codable {
    let name: String
    let email: String
    let password: String
    let weight: Double
    let height: Double
    let gender: String
    let dob: String
}

/*
 Serializing and deserializing of/to JSON make it easier in Swift 4.
 Simply just define the protocol below:
 - Encodable
 - Decodable
 - Codable (Both)
 */
