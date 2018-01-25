//
//  ImageViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 21/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import SwiftCamScanner

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cropView: CropView!
    var image: UIImage?
    
    let inspectionMode = InspectionMode.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func close () {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
         setupCustomNavStatusBar(setting: [.hideStatusBar])
        guard let mode = inspectionMode.mode else { return }
        if (mode == "Food Label") {
            if let image = image {
                cropView.setUpImage(image: image)
            }
        } else {
            cropView.alpha = 0
            imageView.image = image
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
         setupCustomNavStatusBar(setting: [.showStatusBar])
    }
    
    @IBAction func done(sender: UIButton) {
        guard let mode = inspectionMode.mode else { return }
        if (mode == "Food Label") {
            cropView.cropAndTransform(completionHandler: {(croppedImage) -> Void in
                self.imageView.image = croppedImage
                self.imageView.sizeToFit()
                self.cropView.alpha = 0.0
                self.imageView.contentMode = UIViewContentMode.scaleToFill
            })
        } else {
            performSegue(withIdentifier: "showActivityIndicator", sender: sender)
        }
    }
}


