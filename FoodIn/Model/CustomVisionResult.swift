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


/* Example JSON response from Custom Vision Service:

{
    "Created" : "2017-12-26T01:45:42.5927851Z",
    "Id" : "02aa0850-6b6d-4e2f-9a88-c7738eb52bd8",
    "Iteration" : "c7471b23-f5a7-45f3-bd15-8abb39981e21",
    "Predictions" : [
    {
        "Probability" : 0.9815615,
        "Tag" : "Chicken Rice",
        "TagId" : "bb960600-f51a-4b21-b07d-f082bcac6f2f"
    },
    {
        "Probability" : 0.00479447749,
        "Tag" : "Hokkien Mee",
        "TagId" : "5a94d5f9-ead2-4f15-9105-00db18e03554"
    },
    {
        "Probability" : 0.003205916,
        "Tag" : "Mee Rebus",
        "TagId" : "86a87ec5-abe5-4b6e-a4a6-531d051f5eab"
    },
    {
        "Probability" : 0.002275132,
        "Tag" : "Mee Siam",
        "TagId" : "d25079d4-2ac8-4a83-8684-c56bdf687d99"
    },
    {
        "Probability" : 0.000289652264,
        "Tag" : "Durian",
        "TagId" : "ddeffc43-a979-4f53-b511-6bcc8f00ecc3"
    },
    {
        "Probability" : 7.951859e-07,
        "Tag" : "Roti Prata",
        "TagId" : "c0d4cb63-9cc9-4666-8ed4-4f71f367ba60"
    },
    {
        "Probability" : 3.437527e-08,
        "Tag" : "Duck Rice",
        "TagId" : "ab489b58-b906-4a02-bb8c-fecba1e4192b"
    }
    ],
    "Project" : "bfe776d6-191e-485d-83a7-bebf1e42f0d1"
}
 
 */

