//
//  PersonService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 6/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation

class PersonService {
    
    // [GET]
    func checkEmail(email: String, completion: @escaping (Int?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/checkEmail/\(email)") else { return }
        
        // Execute your request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let msgObj = try JSONDecoder().decode(Message.self, from: data)
                print(msgObj.message)
                completion(msgObj.message) // Return your result with completion handler
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
            }.resume()
    }
    
    // [GET]
    func login(email: String, password: String, completion: @escaping (Int?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/login/\(email)/\(password)") else { return }
        
        // Execute your request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let msgObj = try JSONDecoder().decode(Message.self, from: data)
                print(msgObj.message)
                completion(msgObj.message) // Return your result with completion handler
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
            }.resume()
    }
    
    // [POST]
    func register(person: Person, completion: @escaping (Int?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/register") else { return }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let jsonBody = try JSONEncoder().encode(person)
            request.httpBody = jsonBody
        } catch {}
        
        // Execute your request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do{
                let msgObj = try JSONDecoder().decode(Message.self, from: data)
                print(msgObj.message)
                completion(msgObj.message) // Return your result with completion handler
            } catch let jsonError{
                print(jsonError)
                completion(nil)
            }
            }.resume()
    }
    
    // [POST]
    func addPersonIllness(personId: Int, illnessId: Int, completion: @escaping () -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/addPersonIllness/\(personId)/\(illnessId)") else { return }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Execute your request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let msgObj = try JSONDecoder().decode(Message.self, from: data)
                print(msgObj.message)
                completion() // Return after complete
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    // [GET]
    func getPersonDetails(id: Int, completion: @escaping (Person?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/details/\(id)") else { return }
        
        // Execute your request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                print(person)
                completion(person) // Return your result with completion handler
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
            }.resume()
    }
    
    // [GET]
    func getPersonIllness(id: Int, completion: @escaping ([Illness]?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/getIllness/\(id)") else { return }
        
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
    
    // [GET]
    func getIllnessIndicator(id: Int, completion: @escaping ([Indicator]?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/getIllnessIndicator/\(id)") else { return }
        
        // Execute your request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let indicator = try JSONDecoder().decode([Indicator].self, from: data)
                print(indicator)
                completion(indicator) // Return your result with completion handler
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
            }.resume()
    }
    
    // [POST]
    func createFoodLog(personId: Int, food: String, timestamp: UInt64, completion: @escaping (Int?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/logPersonFood/\(personId)/\(food)/\(timestamp) ") else { return }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Execute your request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let result = try JSONDecoder().decode(Int.self, from: data)
                print(result)
                completion(result) // Return your result with completion handler
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
            }.resume()
    }
    
    // [GET]
    func getFoodLog(personId: Int, from: UInt64, to: UInt64, completion: @escaping ([Food]?) -> Void) {
        
        // Define your URL with the combination of Base URL (can be found in global constants) and its Endpoint
        guard let url = URL(string: "\(APIurl.database)/person/getPersonFood/\(personId)/\(from)/\(to)") else { return }
        
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


