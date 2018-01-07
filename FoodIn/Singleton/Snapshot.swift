//
//  Snapshot.swift
//  FoodIn
//
//  Created by Yuanxin Li on 27/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
class Snapshot {
    // singleton
     class var sharedInstance: Snapshot {
        struct Static {
            static let instance = Snapshot()
        }
        return Static.instance
     }
    
    var image: UIImage?
    var imageData: Data?
}



