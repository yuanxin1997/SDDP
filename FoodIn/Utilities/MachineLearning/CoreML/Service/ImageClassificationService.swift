//
//  ImageClassification.swift
//  FoodIn
//
//  Created by Yuanxin Li on 18/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import Vision

// MARK: Handle image classification results
class ImageClassificationService {
    
    // (0%) proximity range get all results. HIGHER proximity range (e.g 90% -> 0.9) get result of HIGHER proximity.
    func filterProximityResults(proximityRangePercent: Float, minimumConfidence: Float, observations: [VNClassificationObservation], completion: @escaping ([PredictionResult]?) -> Void) {
        let classifications = observations
            .filter({ $0.confidence > minimumConfidence })
            .map({($0.identifier, Float($0.confidence))})
        
        let basePercentage = proximityRangePercent
        var firstProximityValue: Float = 0.0
        var proximityResultArr: [PredictionResult] = []
        
        // After declaring new empty array
        // Filter the poximity results by adding them to the new empty array created
        for obj in classifications {
            let value = obj.1
            // Set the first result tag as the base
            if firstProximityValue == 0.0 {
                firstProximityValue = value
                print("first proximity value is \(firstProximityValue)")
                proximityResultArr.append(PredictionResult(identifier: obj.0, confidence: obj.1))
            } else {
                // Check if subsequent result tag is within the proximity range after the base is set
                // If yes, then add them after the first result tag
                let valueProximityPercentage = (value/firstProximityValue)
                if valueProximityPercentage > basePercentage {
                    print("Subsequent proximity value is \(value)")
                    proximityResultArr.append(PredictionResult(identifier: obj.0, confidence: obj.1))
                }
            }
        }
        completion(proximityResultArr)
    }
    
    func printAllResults(observations: [VNClassificationObservation]){
        let classifications = observations.map({ "\($0.identifier) \(String(format:"%.10f%%", Float($0.confidence)*100))" })
        print(classifications.joined(separator: "\n"))
    }
    
    func printResultsCount(observations: [VNClassificationObservation]){
        print(observations.count)
    }
    
    func printBestResult(observations: [VNClassificationObservation]){
        guard let best = observations.first else {
            fatalError("classification didn't return any results")
        }
        print("\(best.identifier) \(String(format:"%.10f%%", Float(best.confidence)*100))")
    }
}


