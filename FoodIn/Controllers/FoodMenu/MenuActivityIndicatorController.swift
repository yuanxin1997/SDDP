//
//  ActivityIndicatorController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 26/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit

import Foundation
import KeychainSwift
class MenuActivityIndicatorController: UIViewController {
    
    var fService = FoodService()
    var tService = TranslateService()
    var foodNameList = [Food]()
    var filteredFoodNameList = [Food]() //update table
    var selectedFoodArr = [Food]()
    var detectedlist:Array = [Food] ()
    var pService = PersonService()
    var arrayOfNutritionalOverLimit:[String] = []
    var safe:Int = 0
    var arrayofsafe:[Int] = []
    var datatec:Int = 0
    var safeFoodNameArray:[Food] = []
    var avoidFoodNameArray:[Food] = []
    var todayLog: [FoodLog]?
    var fullMenuArray:[Food] = []
    var enocrtext: String?
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var bubbleOne: UIImageView!
    @IBOutlet weak var bubbleTwo: UIImageView!
    @IBOutlet weak var bubbleThree: UIImageView!
    
    let snapshot = Snapshot.sharedInstance
    let extractedTextArray = ExtractedTextArray.sharedInstance
    let extractedSafeArray = ExtractedSafeArray.sharedInstance
    let extractedAvoidArray = ExtractedAvoidArray.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelOne.alpha = 0.1
        
        // Start animation chaining
        animateOne()
        
        let vService = VisionService()
        vService.extractText(image: snapshot.image!, completion: { (result: [String: Any]?) in
        //vService.extractText(image: UIImage(named: "menu")!, completion: { (result: [String: Any]?) in
            DispatchQueue.main.async {
                if let result = result {
                    if let responses = result["responses"] as? [[String:Any]], !responses.isEmpty {
                        if let textAnnotations = responses[0]["textAnnotations"] as? [[String: Any]], !textAnnotations.isEmpty {
                            let ocrtext = String(describing: textAnnotations[0]["description"]!).lowercased()
                            print(ocrtext)
                            
                            self.tService.translate(ocrtext, completion: { (result: String) in
                                DispatchQueue.main.async {
                                    self.enocrtext = result
                                    print("this is the en version")
                                    print(self.enocrtext)
                                    self.fService.getFoodNameList(completion: { (result: [Food]?) in
                                        DispatchQueue.main.async {
                                            if let result = result {
                                                self.foodNameList = result
                                                self.filteredFoodNameList = self.foodNameList
                                                //print(self.foodNameList)
                                                
                                                guard let enocrtext = self.enocrtext else { return }
                                                
                                                print("en text \(enocrtext)")
                                                for food in self.filteredFoodNameList {
                                                    //print(food.name)
                                                    
                                                    if enocrtext.lowercased().range(of:food.name.lowercased()) != nil {
                                                        self.detectedlist.append(food)
                                                        print(food.name)
                                                    }
                                                }
                                                print(self.detectedlist)
                                                
                                                
                                                print("Retrieving today's log")
                                                guard let id = Int(KeychainSwift().get("id")!) else { return }
                                                let to = UInt64(floor(Date().endOfDay!.timeIntervalSince1970))
                                                let from = UInt64(floor(Date().startOfDay.timeIntervalSince1970))
                                                self.pService.getFoodLog(personId: id, from: from, to: to, completion: { (result: [FoodLog]?) in
                                                    DispatchQueue.main.async {
                                                        if let result = result {
                                                            self.todayLog = result
                                                            
                                                            for food in self.detectedlist {
                                                                self.inspectFood(food: food)
                                                                print("")
                                                                print("|||||||||")
                                                                print(self.safe)
                                                                print("this is one food")
                                                                print(food.name)
                                                            }
                                                            print("Safe food list consist of...")
                                                            print(self.safeFoodNameArray)
                                                            print("Avoid food list consist of...")
                                                            print(self.avoidFoodNameArray)
                                                            
                                                            self.extractedTextArray.objectArray = self.fullMenuArray
                                                            self.extractedSafeArray.objectArray = self.safeFoodNameArray
                                                            self.extractedAvoidArray.objectArray = self.avoidFoodNameArray
                                                            
                                                            self.performSegue(withIdentifier: "showMenuResults", sender: nil)
                                                        }
                                                    }
                                                })
                                            }
                                        }})
                                }
                            })
                        }
                    }
                }
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.blackStatusBar])
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // First element in animation chaining
    func animateOne() {
        UIView.animate(withDuration: 1, animations: {
            self.bubbleOne?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.switchLabelAlpha()
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleOne?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.switchLabelAlpha()
            }) { (true) in
                self.animateTwo()
            }
        }
    }
    
    // Second element in animation chaining
    func animateTwo() {
        UIView.animate(withDuration: 1.5, animations: {
            self.bubbleTwo?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.switchLabelAlpha()
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleTwo?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.switchLabelAlpha()
            }) { (true) in
                self.animateThree()
            }
        }
    }
    
    // Third element in animation chaining
    func animateThree() {
        UIView.animate(withDuration: 1.5, animations: {
            self.bubbleThree?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.switchLabelAlpha()
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleThree?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.switchLabelAlpha()
            }) { (true) in
                self.animateOne()
            }
        }
    }
    
    // Fading animation for label
    func switchLabelAlpha() {
        if self.labelOne.alpha == 1 {
            self.labelOne.alpha = 0.1
        } else {
            self.labelOne.alpha = 1
        }
    }
    
    func inspectFood(food: Food) {
        if let todayLog = self.todayLog {
            let myIndicator = MyIndicatorService().getMyIndicator()
            let foodMirror = Mirror(reflecting: food)
            for (name, value) in foodMirror.children {
                for i in myIndicator {
                    if name == i.name {
                        let valueToMatch = value as! Double
                        var logValue = self.getTotalValueFromLog(foods: todayLog, indicatorName: i.name!)
                        logValue += valueToMatch
                        
                        print("\(food.name) \(i.name!): \(logValue) xd \(i.maxValue)")
                        
                        if logValue > i.maxValue {
                            self.arrayOfNutritionalOverLimit.append(name!)
                        }
                    }
                }
                
            }
            self.safe = 0
            self.determineSafeOrAvoid()
            
            if self.safe == 1{
                self.safeFoodNameArray.append(food)
                self.fullMenuArray.append(food)
                self.arrayOfNutritionalOverLimit = []
                
            }
            if self.safe == 2{
                self.avoidFoodNameArray.append(food)
                self.fullMenuArray.append(food)
                self.arrayOfNutritionalOverLimit = []
            }
            if self.safe == 0{
                
            }
            
        }
    }
    
    func determineSafeOrAvoid(){
        
        if arrayOfNutritionalOverLimit.count > 0 {
            self.safe = 2
        }
        else if arrayOfNutritionalOverLimit.count == 0 {
            self.safe = 1
        }
        else{
            self.safe = 0
        }
    }
    
    func getTotalValueFromLog(foods: [FoodLog], indicatorName: String) -> Double {
        var m = "0"
        var totalValue = 0.0
        for food in foods {
            let foodMirror = Mirror(reflecting: food)
            for (name, value) in foodMirror.children {
                if name == indicatorName {
                    let valueToSum = value as! Double
                    totalValue += valueToSum
                    m += " + \(valueToSum)"
                }
            }
        }
        print("\(foods.count) \(indicatorName) \(m) = \(totalValue)")
        return totalValue
    }
}


