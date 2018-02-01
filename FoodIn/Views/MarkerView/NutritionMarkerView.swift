//
//  Nutrient.swift
//  FoodIn
//
//  Created by ryan on 12/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import Charts

class NutrientMarkerView: MarkerView {
    
    @IBOutlet var label: UILabel!
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    public override func awakeFromNib() {
        self.offset.x = -self.frame.size.width / 2.0
        self.offset.y = -self.frame.size.height - 7.0
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = String.init(format: "%d %%", Int(round(entry.y)))
        layoutIfNeeded()
    }
}
