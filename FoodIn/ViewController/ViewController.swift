//
//  ViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 17/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // SAMPLE 1
//        var email1 = "wayne@gmail.com"
//        checkEmail(email: email1);
//
//        // SAMPLE 2
//        var email2 = "zhiyong@gmail.com"
//        var password = "123"
//        login(email: email2, password: password)
        
//        // SAMPLE 3
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let result = formatter.string(from: date)
//        let person = Person(name: "kenny", email: "kenny@gmail.com", password: "pass", weight: 70, height: 180, gender: "male", dob: result)
//        print(person)
//        register(person: person)
        
        // SAMPLE 4
        var email3 = "kenny@gmail.com"
        getPersonDetails(email: email3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    func getPersonDetails(email: String) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/details/\(email)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, response != nil, error == nil else { return }
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                print(person)
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
    
    func login(email: String, password: String) {
        guard let url = URL(string: "https://foodin-api.herokuapp.com/person/login/\(email)/\(password)") else { return }
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
    
    func register(person: Person) {
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
            } catch let jsonError{
                print(jsonError)
            }
        }.resume()
    }
}



