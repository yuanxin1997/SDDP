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
import AVFoundation

class ResultMenuViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var sodiumBar: GTProgressBar!
    @IBOutlet weak var potassiumBar: GTProgressBar!
    @IBOutlet weak var calciumBar: GTProgressBar!
    @IBOutlet weak var ironBar: GTProgressBar!
    @IBOutlet weak var caloriesBar: GTProgressBar!
    @IBOutlet weak var carbohydrateBar: GTProgressBar!
    @IBOutlet weak var fatBar: GTProgressBar!
    @IBOutlet weak var proteinBar: GTProgressBar!
    
    @IBOutlet weak var sodiumLabel: EFCountingLabel!
    @IBOutlet weak var potassiumLabel: EFCountingLabel!
    @IBOutlet weak var calciumLabel: EFCountingLabel!
    @IBOutlet weak var ironLabel: EFCountingLabel!
    @IBOutlet weak var caloriesLabel: EFCountingLabel!
    @IBOutlet weak var carbohydrateLabel: EFCountingLabel!
    @IBOutlet weak var fatLabel: GTProgressBar!
    @IBOutlet weak var proteinLabel: EFCountingLabel!
    
    @IBOutlet weak var enFood: UILabel!
    @IBOutlet weak var cnFood: UILabel!
    @IBOutlet weak var jpFood: UILabel!
    @IBOutlet weak var krFood: UILabel!
    
    
    @IBOutlet weak var enListen: UIButton!
    @IBOutlet weak var cnListen: UIButton!
    @IBOutlet weak var jpListen: UIButton!
    @IBOutlet weak var krListen: UIButton!
    
    let fService = FoodService()
    var selectedFood : Food?
    let tService = TranslateService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enFood.text = selectedFood?.name
        
        tService.translate(selectedFood!.name, to:"zh-CN",  completion: { (result: String) in
            DispatchQueue.main.async {
                print("Translation: \(result)")
                self.cnFood.text = result
            }
        })
        
        tService.translate(selectedFood!.name, to:"ja",  completion: { (result: String) in
            DispatchQueue.main.async {
                print("Translation: \(result)")
                self.jpFood.text = result
            }
        })
        
        tService.translate(selectedFood!.name, to:"ko",  completion: { (result: String) in
            DispatchQueue.main.async {
                print("Translation: \(result)")
                self.krFood.text = result
            }
        })
        print("")
        print(selectedFood!)
        
        navigationItem.title = selectedFood?.name
        
        // Initialize
        initProgressBar()
        
        // Setup with data
        setupProgressBar()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func listenen(){
        
        let string = enFood.text
        let utterance = AVSpeechUtterance(string: string!)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @IBAction func listencn(){
        
        let string = cnFood.text
        let utterance = AVSpeechUtterance(string: string!)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @IBAction func listenjp(){
        
        let string = jpFood.text
        let utterance = AVSpeechUtterance(string: string!)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    @IBAction func listenkr(){
        
        let string = krFood.text
        let utterance = AVSpeechUtterance(string: string!)
        utterance.voice = AVSpeechSynthesisVoice(language: "ko-KR")
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
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
            if let foodDetails = self.selectedFood {
                self.progressBarUpdate(mgOfSodium: foodDetails.sodium, mgOfPotassium: foodDetails.potassium, mgOfCalcium: foodDetails.calcium, mgOfIron: foodDetails.iron)
            }
        }
    }
    
    func progressBarUpdate(mgOfSodium: Double, mgOfPotassium: Double, mgOfCalcium: Double, mgOfIron: Double){
        
        // Get recommendation standard
        let myInfo = MyInfoService().getMyInfo()[0]
        let myIndicator = MyIndicatorService().getMyIndicator()
        var myRS = RecommendationStandard(info: myInfo).with(indicator: myIndicator)
        
        // End point of progress bar
        let sodiumPoint = CGFloat(mgOfSodium/myRS.sodium!)
        let potassiumPoint = CGFloat(mgOfPotassium/myRS.potassium!)
        let calciumPoint = CGFloat(mgOfCalcium/myRS.calcium!)
        let ironPoint = CGFloat(mgOfIron/myRS.iron!)
        
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



