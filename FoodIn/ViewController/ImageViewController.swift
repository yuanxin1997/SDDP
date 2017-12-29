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
    var imageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBAction func close () {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         UIApplication.shared.isStatusBarHidden = false
    }
    
    @IBAction func done(sender: UIButton) {
        guard let image = image else {
            return
        }
        performSegue(withIdentifier: "showActivityIndicator", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showActivityIndicator" {
            let aic = segue.destination as! ActivityIndicatorController
            aic.imageData = self.imageData
            aic.image = self.image
        }
    }
}


