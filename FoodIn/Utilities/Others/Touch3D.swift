//
//  Touch3D.swift
//  FoodIn
//
//  Created by Yuanxin Li on 9/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import UIKit

class Touch3D {
    
    func enableQuickAction() {
        // Set your quick action icon
        let icon = UIApplicationShortcutIcon(type: .capturePhoto)
        
        // Create your quick action items
        let item1 = UIApplicationShortcutItem(type: "com.yuanxin.FoodIn.snapFoodLabel", localizedTitle: "Snap Food Label", localizedSubtitle: nil, icon: icon, userInfo: nil)
        let item2 = UIApplicationShortcutItem(type: "com.yuanxin.FoodIn.snapFoodMenu", localizedTitle: "Snap Food Menu", localizedSubtitle: nil, icon: icon, userInfo: nil)
        let item3 = UIApplicationShortcutItem(type: "com.yuanxin.FoodIn.snapFoodItem", localizedTitle: "Snap Food Item", localizedSubtitle: nil, icon: icon, userInfo: nil)
        
        // Add all them to the array
        UIApplication.shared.shortcutItems = [item1, item2, item3]
    }
    
    func disableQuickAction() {
        // clear the array
        UIApplication.shared.shortcutItems = []
    }
    
}
