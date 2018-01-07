//
//  IllnessService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 6/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation

class IllnessService {
    
    func getIllnessList(completion: @escaping ([Illness]?, Error?) -> Void) {
        
        guard let url = URL(string: "https://foodin-api.herokuapp.com/illness/all") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let result = try JSONDecoder().decode([Illness].self, from: data)
                print(result)
                completion(result, nil)
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func getIllnessIndicator(id: Int, completion: @escaping (Indicator?) -> Void) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/illness/getIllnessIndicator/\(id)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let indicator = try JSONDecoder().decode(Indicator.self, from: data)
                print(indicator)
                completion(indicator)
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }
}
