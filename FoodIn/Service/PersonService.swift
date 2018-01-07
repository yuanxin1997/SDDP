//
//  PersonService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 6/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation

class PersonService {
    
    func checkEmail(email: String) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/checkEmail/\(email)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let msgObj = try JSONDecoder().decode(Message.self, from: data)
                print(msgObj.message)
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func login(email: String, password: String, completion: @escaping (Int?) -> Void) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/login/\(email)/\(password)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let msgObj = try JSONDecoder().decode(Message.self, from: data)
                print(msgObj.message)
                completion(msgObj.message)
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }
    
    func register(person: Person, completion: @escaping (Int?) -> Void) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/register") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            let jsonBody = try JSONEncoder().encode(person)
            request.httpBody = jsonBody
        } catch {}
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do{
                let msgObj = try JSONDecoder().decode(Message.self, from: data)
                print(msgObj.message)
                completion(msgObj.message)
            } catch let jsonError{
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }
    
    func addPersonIllness(personId: Int, illnessId: Int, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/addPersonIllness/\(personId)/\(illnessId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let msgObj = try JSONDecoder().decode(Message.self, from: data)
                print(msgObj.message)
                completion()
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    func getPersonDetails(id: Int, completion: @escaping (Person?) -> Void) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/details/\(id)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                print(person)
                completion(person)
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }
    
    func getPersonIllness(id: Int, completion: @escaping ([Illness]?) -> Void) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/getIllness/\(id)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let illness = try JSONDecoder().decode([Illness].self, from: data)
                print(illness)
                completion(illness)
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }
    
    func getIllnessIndicator(id: Int, completion: @escaping ([Indicator]?) -> Void) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/getIllnessIndicator/\(id)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let indicator = try JSONDecoder().decode([Indicator].self, from: data)
                print(indicator)
                completion(indicator)
            } catch let jsonError {
                print(jsonError)
                completion(nil)
            }
        }.resume()
    }
    
}
