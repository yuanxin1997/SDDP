//
//  FoodService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 30/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

class FoodService {
    
    // [GET] 
    func getFoodDetails(foodName: String, completion: @escaping (Food?) -> Void) {
        
        // To allow spacing between characters in a return string
        let encodedString = foodName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)!
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/food/details/\(encodedString)") else { return }
        
        // Execute your request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let food = try JSONDecoder().decode(Food.self, from: data)
                print(food)
                completion(food) // Return your result with completion handler
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }
    
    
    func getFoodNameList(completion: @escaping ([Food]?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/food/all") else { return }
        
        // Execute your request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let food = try JSONDecoder().decode([Food].self, from: data)
                print(food)
                completion(food) // Return your result with completion handler
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }


}
