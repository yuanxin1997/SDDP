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
    
    func sendMessage(text: String?, completion: @escaping (AIResponse?) -> Void) {
        let request = ApiAI.shared().textRequest()
        
        if let text = text, text != "" {
            request?.query = text
        } else { return }
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            completion(response)
        }, failure: { (request, error) in
            print(error!)
        })
        
        ApiAI.shared().enqueue(request)
    }
    
}
