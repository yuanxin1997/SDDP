//
//  IllnessService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 6/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation

class IllnessService {
    
    // [POST]
    func getIllnessList(completion: @escaping ([Illness]?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/illness/all") else { return }
        
        // Execute your request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let illness = try JSONDecoder().decode([Illness].self, from: data)
                print(illness)
                completion(illness) // Return your result with completion handler
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }

}
