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
    let weight: Decimal
    let height: Decimal
    let gender: String
    let dob: String
}

