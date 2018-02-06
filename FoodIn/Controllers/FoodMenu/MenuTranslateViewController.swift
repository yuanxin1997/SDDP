//
//  MineralViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 27/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import AVFoundation

class MenuTranslateViewController: UIViewController, IndicatorInfoProvider {
    
    
    @IBOutlet weak var enFood: UILabel!
    @IBOutlet weak var cnFood: UILabel!
    @IBOutlet weak var jpFood: UILabel!
    @IBOutlet weak var krFood: UILabel!
    
    
    @IBOutlet weak var enListen: UIButton!
    @IBOutlet weak var cnListen: UIButton!
    @IBOutlet weak var jpListen: UIButton!
    @IBOutlet weak var krListen: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
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
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Translate")
    }
    
}


