//
//  VisionService.swift
//  FoodIn
//
//  Created by ryan on 25/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import UIKit

class VisionService {
    
    // [POST]
    func extractText(image: UIImage, completion: @escaping ([String: Any]?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.googleVision)?key=\(APIkeys.google)") else { return }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let imageBase64 = ImageUtils.base64EncodeImage(image)
        do{
            let jsonBody = [
                "requests": [
                    "image": [
                        "content": imageBase64
                    ],
                    "features": [
                        [
                            "type": "TEXT_DETECTION"
                        ]
                    ]
                ]
                ] as [String : Any]
            let jsonData = try! JSONSerialization.data(withJSONObject: jsonBody)
            request.httpBody = jsonData
        } catch {}
        
        // Execute your request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do{
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    completion(responseJSON) // Return your result with completion handler
                }
                
            } catch let jsonError{
                print(jsonError)
                completion(nil)
            }
            }.resume()
    }
}

