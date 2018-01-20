//
//  MineralViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 27/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import GTProgressBar
import EFCountingLabel

class MineralViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var sodiumBar: GTProgressBar!
    @IBOutlet weak var potassiumBar: GTProgressBar!
    @IBOutlet weak var calciumBar: GTProgressBar!
    @IBOutlet weak var ironBar: GTProgressBar!
    
    @IBOutlet weak var sodiumLabel: EFCountingLabel!
    @IBOutlet weak var potassiumLabel: EFCountingLabel!
    @IBOutlet weak var calciumLabel: EFCountingLabel!
    @IBOutlet weak var ironLabel: EFCountingLabel!
    let fService = FoodService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize
        initProgressBar()
        
        // Setup with data
        setupProgressBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initProgressBar() {
        sodiumBar.progress = 0
        potassiumBar.progress = 0
        calciumBar.progress = 0
        ironBar.progress = 0
        
        sodiumLabel.text = "0 mg"
        potassiumLabel.text = "0 mg"
        calciumLabel.text = "0 mg"
        ironLabel.text = "0 mg"
    }
    
    func setupProgressBar() {
        DispatchQueue.main.async {
            if let foodDetails = FoodDetailsController.selectedFood {
                self.progressBarUpdate(mgOfSodium: foodDetails.sodium, mgOfPotassium: foodDetails.potassium, mgOfCalcium: foodDetails.calcium, mgOfIron: foodDetails.iron)
            }
        }
    }
    
    func progressBarUpdate(mgOfSodium: Double, mgOfPotassium: Double, mgOfCalcium: Double, mgOfIron: Double){
        // FDA Daily Nutritional Recommendation (based on 2000 calories per day)
        // sodium -> 2400mg
        // postassium -> 3000mg
        // calcium -> 1000mg
        // iron -> 18mg
        let sodiumPoint = CGFloat(mgOfSodium/2400)
        let potassiumPoint = CGFloat(mgOfPotassium/3000)
        let calciumPoint = CGFloat(mgOfCalcium/1000)
        let ironPoint = CGFloat(mgOfIron/18)
        
        // Bar animation
        sodiumBar.animateTo(progress: sodiumPoint)
        potassiumBar.animateTo(progress: potassiumPoint)
        calciumBar.animateTo(progress: calciumPoint)
        ironBar.animateTo(progress: ironPoint)
        
        // Label animation
        sodiumLabel.countFrom(0, to: CGFloat(mgOfSodium), withDuration: 1)
        potassiumLabel.countFrom(0, to: CGFloat(mgOfPotassium), withDuration: 1)
        calciumLabel.countFrom(0, to: CGFloat(mgOfCalcium), withDuration: 1)
        ironLabel.countFrom(0, to: CGFloat(mgOfIron), withDuration: 1)
        
        sodiumLabel.attributedFormatBlock = {
            (value) in
            let prefix = String(format: "%d", Int(value))
            let postfix = String(format: " mg")
            
            let prefixAttr = NSMutableAttributedString(string: prefix)
            let postfixAttr = NSAttributedString(string: postfix)
            
            prefixAttr.append(postfixAttr)
            return prefixAttr
        }
        
        potassiumLabel.attributedFormatBlock = {
            (value) in
            let prefix = String(format: "%d", Int(value))
            let postfix = String(format: " mg")
            
            let prefixAttr = NSMutableAttributedString(string: prefix)
            let postfixAttr = NSAttributedString(string: postfix)
            
            prefixAttr.append(postfixAttr)
            return prefixAttr
        }
        
        calciumLabel.attributedFormatBlock = {
            (value) in
            let prefix = String(format: "%d", Int(value))
            let postfix = String(format: " mg")
            
            let prefixAttr = NSMutableAttributedString(string: prefix)
            let postfixAttr = NSAttributedString(string: postfix)
            
            prefixAttr.append(postfixAttr)
            return prefixAttr
        }
        
        ironLabel.attributedFormatBlock = {
            (value) in
            let prefix = String(format: "%d", Int(value))
            let postfix = String(format: " mg")
            
            let prefixAttr = NSMutableAttributedString(string: prefix)
            let postfixAttr = NSAttributedString(string: postfix)
            
            prefixAttr.append(postfixAttr)
            return prefixAttr
        }
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Mineral")
    }

}
