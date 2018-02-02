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
class LabelActivityIndicatorController: UIViewController {

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
            //vService.extractText(image: UIImage(named: "menu")!, completion: { (result: [String: Any]?) in
            DispatchQueue.main.async {
                if let result = result {
                    if let responses = result["responses"] as? [[String:Any]], !responses.isEmpty {
                        if let textAnnotations = responses[0]["textAnnotations"] as? [[String: Any]], !textAnnotations.isEmpty {
                            let ocrtext = String(describing: textAnnotations[0]["description"]!).lowercased()
                            print(ocrtext)
                            
                            var data = [
                                "calories": 0.0,
                                "carbohydrate": 0.0,
                                "fat": 0.0,
                                "protein": 0.0,
                                "vitamin a": 0.0,
                                "vitamin c": 0.0,
                                "sodium": 0.0,
                                "potassium": 0.0,
                                "calcium": 0.0,
                                "iron": 0.0,
                                "saturated": 0.0,
                                "trans": 0.0
                            ]
                            
                            for (key, value) in data {
                                let regexStr = "(\(key)[a-zA-Z /]+)[\n| ]*([\\d| ]+)+[\n| ]*(\\w+)*"
                                let matches = self.matches(for: regexStr, in: ocrtext)
                                print(matches)
                                if matches.count > 0 {
                                    let amount = Double(matches[0][2].trimmingCharacters(in: .whitespacesAndNewlines))
                                    data[key] = amount != nil ? amount : 0.0
                                }
                            }
                            
                            if let fat = data["fat"], fat == 0 {
                                if let sat = data["saturated"] {
                                    data["fat"]! += sat
                                }
                                if let trans = data["saturated"] {
                                    data["fat"]! += trans
                                }
                            }
                            
                            LabelResults.sharedInstance.data = data
                            print(data)
                            
                            self.performSegue(withIdentifier: "showLabelResults", sender: nil)
                            
                        }
                    }
                }
            }
        })
    }
    
    
    func matches(for regex: String, in text: String) -> [[String]] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSMakeRange(0, text.count))
            let nsStr = NSString(string: text)
            return results.map {
                var matches: [String] = []
                for i in 0...2 {
                    matches.append(nsStr.substring(with: $0.range(at: i)))
                }
                return matches
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
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



