//
//  Fonts.swift
//  FoodIn
//
//  Created by Yuanxin Li on 9/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import UIKit

enum Fonts: String {
    
    // Global font family
    case Regular = "Arial Rounded MT Bold"
    
    // Global dynamic font size
    func of(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
    
}
