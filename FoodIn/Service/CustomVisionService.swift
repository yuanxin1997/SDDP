//
//  CustomVisionService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 20/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

class CustomVisionService {
    var preductionUrl = "https://southcentralus.api.cognitive.microsoft.com/customvision/v1.1/Prediction/bfe776d6-191e-485d-83a7-bebf1e42f0d1/image"
    var predictionKey = "0d32ece634bb43fcbc49814e96fe57fe"
    var contentType = "application/octet-stream"
    
    func predict(image: Data, completion: @escaping (CustomVisionResult?, Error?) -> Void) {
        
        guard let url = URL(string: preductionUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(predictionKey, forHTTPHeaderField: "Prediction-Key")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
  
        URLSession.shared.uploadTask(with: request, from: image) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do{
                let result = try JSONDecoder().decode(CustomVisionResult.self, from: data)
                print(result)
                completion(result, nil)
            } catch let jsonError{
                print(jsonError)
            }
        }.resume()
    }
    
    // (0%) proximity range get all results. HIGHER proximity range (e.g 90% -> 0.9) get result of HIGHER proximity.
    func filterProximityResults(proximityRangePercent: Double, result: CustomVisionResult) -> [CustomVisionPrediction] {
        let basePercentage = proximityRangePercent
        var firstProximityValue:Double = 0.0
        var proximityResultArr = [CustomVisionPrediction]()
        
        for obj in result.Predictions {
            let value = obj.Probability
            if firstProximityValue == 0.0 {
                firstProximityValue = value
                print("first proximity value is \(firstProximityValue)")
                proximityResultArr.append(obj)
            } else {
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
