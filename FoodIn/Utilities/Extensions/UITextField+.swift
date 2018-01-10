//
//  CustomTextField.swift
//  FoodIn
//
//  Created by Yuanxin Li on 4/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {}

extension UITextField
{
    
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
    
}
