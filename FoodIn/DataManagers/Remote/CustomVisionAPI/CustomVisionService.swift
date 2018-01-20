//
//  CustomVisionService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 20/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

//  This service will now be deprecated for this project
class CustomVisionService {
    var predictionKey = "0d32ece634bb43fcbc49814e96fe57fe"
    var contentType = "application/octet-stream"
    
    // [POST] 
    func predict(image: Data, completion: @escaping (CustomVisionResult?) -> Void) {
        
        // Define your URL (can be found in global constants)
        guard let url = URL(string: APIurl.customVision) else { return }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(predictionKey, forHTTPHeaderField: "Prediction-Key")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // Execute your request
        URLSession.shared.uploadTask(with: request, from: image) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do{
                let customVisionResult = try JSONDecoder().decode(CustomVisionResult.self, from: data)
                print(customVisionResult)
                completion(customVisionResult) // Return your result with completion handler
            } catch let jsonError{
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }
    
    // (0%) proximity range get all results. HIGHER proximity range (e.g 90% -> 0.9) get result of HIGHER proximity.
    func filterProximityResults(proximityRangePercent: Double, result: CustomVisionResult) -> [CustomVisionPrediction] {
        let basePercentage = proximityRangePercent
        var firstProximityValue:Double = 0.0
        var proximityResultArr = [CustomVisionPrediction]()
        
        // After declaring new empty array
        // Filter the poximity results by adding them to the new empty array created
        for obj in result.Predictions {
            let value = obj.Probability
            // Set the first result tag as the base
            if firstProximityValue == 0.0 {
                firstProximityValue = value
                print("first proximity value is \(firstProximityValue)")
                proximityResultArr.append(obj)
            } else {
                // Check if subsequent result tag is within the proximity range after the base is set
                // If yes, then add them after the first result tag
                let valueProximityPercentage = (value/firstProximityValue)
                if valueProximityPercentage > basePercentage {
                    print("Subsequent proximity value is \(value)")
                    proximityResultArr.append(obj)
                }
            }
        }

        
        return proximityResultArr
    }
    
}
