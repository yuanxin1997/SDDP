//
//  MessageCell.swift
//  FoodIn
//
//  Created by Yuanxin Li on 22/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
