//
//  Illness.swift
//  FoodIn
//
//  Created by Yuanxin Li on 6/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation

struct Illness: Decodable {
    let id: Int
    let name: String
}

/*
 Serializing and deserializing of/to JSON make it easier in Swift 4.
 Simply just define the protocol below:
 - Encodable
 - Decodable
 - Codable (Both)
 */

