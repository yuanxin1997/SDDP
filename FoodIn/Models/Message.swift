//
//  Message.swift
//  FoodIn
//
//  Created by Yuanxin Li on 17/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

struct Message: Decodable {
    let message: Int
}

/*
 Serializing and deserializing of/to JSON make it easier in Swift 4.
 Simply just define the protocol below:
 - Encodable
 - Decodable
 - Codable (Both)
 */

