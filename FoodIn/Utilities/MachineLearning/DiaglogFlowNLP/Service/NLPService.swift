//
//  NLPService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 22/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import AVFoundation
import ApiAI

class NLPService {
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func sendMessage(text: String?, completion: @escaping (String?) -> Void) {
        let request = ApiAI.shared().textRequest()
        
        if let text = text, text != "" {
            request?.query = text
        } else { return }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if let textResponse = response.result.fulfillment.speech {
                print(textResponse)
                self.speechAndText(text: textResponse)
                completion(textResponse)
            }
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
    }
    
    func speechAndText(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        speechUtterance.pitchMultiplier = 0.85
        speechUtterance.rate = 0.45
        speechSynthesizer.speak(speechUtterance)
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
        }, completion: nil)
    }
    
}
