//
//  ActivityIndicatorController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 26/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit

import Foundation

class MenuActivityIndicatorController: UIViewController {
    
    var fService = FoodService()
    var foodNameList = [Food]()
    var filteredFoodNameList = [Food]() //update table
    var selectedFoodArr = [Food]()
    var detectedlist:Array = [Food] ()
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var bubbleOne: UIImageView!
    @IBOutlet weak var bubbleTwo: UIImageView!
    @IBOutlet weak var bubbleThree: UIImageView!
    
    let snapshot = Snapshot.sharedInstance
    let extractedTextArray = ExtractedTextArray.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelOne.alpha = 0.1
        
        // Start animation chaining
        animateOne()
        
        let vService = VisionService()
        vService.extractText(image: snapshot.image!, completion: { (result: [String: Any]?) in
            DispatchQueue.main.async {
                if let result = result {
                    if let responses = result["responses"] as? [[String:Any]], !responses.isEmpty {
                        if let textAnnotations = responses[0]["textAnnotations"] as? [[String: Any]], !textAnnotations.isEmpty {
                            let ocrtext = String(describing: textAnnotations[0]["description"]!).lowercased()
                            print(ocrtext)
                            //for count of data loop max
                            //get name
                            //filter
                            //add new array insert name
                            //display base on sodium intake for the day max
                            
                            let fService = FoodService()
                            
                            fService.getFoodNameList(completion: { (result: [Food]?) in
                                DispatchQueue.main.async {
                                    if let result = result {
                                        self.foodNameList = result
                                        self.filteredFoodNameList = self.foodNameList
                                        //print(self.foodNameList)
                                        
                                        for food in self.filteredFoodNameList {
                                            //print(food.name)
                                            
                                            if ocrtext.range(of:food.name.lowercased()) != nil {
                                                self.detectedlist.append(food)
                                                print(food.name)
                                            }
                                        }
                                        print(self.detectedlist)
                                        self.extractedTextArray.objectArray = self.detectedlist
                                        self.performSegue(withIdentifier: "showMenuResults", sender: nil)
                                        
                                    }
                                }})
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
    
}


