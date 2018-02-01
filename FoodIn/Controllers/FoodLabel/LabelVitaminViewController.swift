//
//  VitaminViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 27/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import UICircularProgressRing

class LabelVitaminViewController: UIViewController, IndicatorInfoProvider, UICircularProgressRingDelegate {
    
    @IBOutlet weak var ringVitaminA: UICircularProgressRingView!
    @IBOutlet weak var ringVitaminC: UICircularProgressRingView!
    
    var fService = FoodService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize
        initCircularProgressBar()
        
        // Setup with data
        setupCircularProgressBar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCircularProgressBar(){
        
        // Set the delegate
        ringVitaminA.delegate = self
        ringVitaminC.delegate = self
        
        // Set start value and max value
        ringVitaminA.maxValue = 100
        ringVitaminC.maxValue = 100
        ringVitaminA.value = 0
        ringVitaminC.value = 0
    }
    
    func setupCircularProgressBar(){
        DispatchQueue.main.async {
            if let data = LabelResults.sharedInstance.data {
                self.circularProgressBarUpdate(mcgOfvitaminA: data["vitamin a"]!, mcgOfvitaminC: data["vitamin c"]!)
            }
        }
    }
    
    func circularProgressBarUpdate(mcgOfvitaminA: Double, mcgOfvitaminC: Double){
        
        // vitaminA value received from database is in (mcg)
        // IU of vitamin A -> IU =  3.33 * mcg
        // 5000 IU of vitamin A = 100% daily value
        let IUofVitaminA = 3.33 * mcgOfvitaminA
        let dvOfVitaminA = CGFloat(mcgOfvitaminA.roundTo(places: 2))
        
        // vitaminC value received from database is in (mg)
        // 60 mg of vitamin C = 100% daily value
        let dvOfVitaminC = CGFloat(mcgOfvitaminC.roundTo(places: 2))
        
        // Ring animation
        ringVitaminA.animationStyle = kCAMediaTimingFunctionLinear
        ringVitaminA.setProgress(value: dvOfVitaminA, animationDuration: 1)
        
        ringVitaminC.animationStyle = kCAMediaTimingFunctionLinear
        ringVitaminC.setProgress(value: dvOfVitaminC, animationDuration: 1)
    }
    
    func finishedUpdatingProgress(forRing ring: UICircularProgressRingView) {
        if ring === ringVitaminA {
            print("From delegate: Ring vitaminA finished")
        } else if ring === ringVitaminC {
            print("From delegate: Ring vitaminC finished")
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Vitamin")
    }
    
}


