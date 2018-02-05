//
//  TranslateService.swift
//  FoodIn
//
//  Created by Admin on 6/2/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import ROGoogleTranslate

class TranslateService {
    
    func translate (_ text: String, to: String = "en", completion: @escaping (String) -> Void) {
        let translator = ROGoogleTranslate()
        translator.apiKey = "AIzaSyAICVslGjLgnwYUVf-bkmFd-lUBapn5Mnk" // Add your API Key here
        
        var params = ROGoogleTranslateParams()
        params.source = ""
        params.target = to
        params.text = text
        
        translator.translate(params: params) { (result) in
            completion(String(result))
        }
    }
}

