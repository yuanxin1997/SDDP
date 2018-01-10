//
//  IllnessCheckbox.swift
//  FoodIn
//
//  Created by Yuanxin Li on 6/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import CheckboxButton

class IllnessCheckbox: UITableViewCell {

    @IBOutlet weak var checkBox: CheckboxButton!
    @IBOutlet weak var illnessLabel: UILabel!
    var illnessId: Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
