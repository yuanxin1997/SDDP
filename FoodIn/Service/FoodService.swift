//
//  FoodService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 30/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import Foundation

class FoodService {
    
    func getFoodDetails(foodName: String, completion: @escaping (Food?, Error?) -> Void) {
        
        let encodedString = foodName.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlFragmentAllowed)!
        guard let url = URL(string: "https://foodin-api.herokuapp.com/food/details/\(encodedString)") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(Food.self, from: data)
                print(result)
                completion(result, nil)
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }

}
