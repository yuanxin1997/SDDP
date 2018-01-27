//
//  ImageViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 21/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    let inspectionMode = InspectionMode.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func closeBtnDidTap() {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
         setupCustomNavStatusBar(setting: [.hideStatusBar])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
         setupCustomNavStatusBar(setting: [.showStatusBar])
    }
    
    @IBAction func done(sender: UIButton) {
        print(inspectionMode.mode)

        if inspectionMode.mode! == "Food Menu" {
            performSegue(withIdentifier: "showMenuActivityIndicator", sender: sender)
        } else if inspectionMode.mode! == "Food Label" {
            performSegue(withIdentifier: "showActivityIndicator", sender: sender)
        } else if inspectionMode.mode! == "Food Item" {
            performSegue(withIdentifier: "showActivityIndicator", sender: sender)
        }
        
    }
}


