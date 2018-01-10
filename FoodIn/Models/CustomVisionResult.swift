//
//  CustomVisionResult.swift
//  FoodIn
//
//  Created by Yuanxin Li on 21/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

struct CustomVisionPrediction: Decodable {
    let TagId: String
    let Tag: String
    let Probability: Double
}

struct CustomVisionResult: Decodable {
    let Id: String
    let Project: String
    let Iteration: String
    let Created: String
    let Predictions: [CustomVisionPrediction]
}

/*
 Serializing and deserializing of/to JSON make it easier in Swift 4.
 Simply just define the protocol below:
 - Encodable
 - Decodable
 - Codable (Both)
 */



