//
//  CustomTextField.swift
//  FoodIn
//
//  Created by Yuanxin Li on 4/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import AudioToolbox

public enum txtfieldType {
    case clear
    case error
}

extension UITextField {
    
    public func setFieldType(type: txtfieldType){
        switch type {
        case .clear:
            setBottomBorder(borderColor: Colors.lightgrey)
        case .error:
            setBottomBorder(borderColor: Colors.hotRed)
            self.shake()
        default:
            setBottomBorder(borderColor: Colors.lightgrey)
        }
    }
    
    // Bottom border
    func setBottomBorder(borderColor: UIColor) {
        self.borderStyle = UITextBorderStyle.none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = borderColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    // Shake text field and vibrate phone
    func shake () {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 6, y: self.center.y + 2))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 6, y: self.center.y - 2))
        self.layer.add(animation, forKey: "position")
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
    }
    
}
