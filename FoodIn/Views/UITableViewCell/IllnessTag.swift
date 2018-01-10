//
//  IllnessTag.swift
//  FoodIn
//
//  Created by Yuanxin Li on 8/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit

class IllnessTag: UITableViewCell {

    @IBOutlet weak var illnessIndexLabel: UILabel!
    @IBOutlet weak var illnessNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
