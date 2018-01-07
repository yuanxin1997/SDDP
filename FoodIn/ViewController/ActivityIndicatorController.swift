//
//  ActivityIndicatorController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 26/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit

class ActivityIndicatorController: UIViewController {

    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var bubbleOne: UIImageView!
    @IBOutlet weak var bubbleTwo: UIImageView!
    @IBOutlet weak var bubbleThree: UIImageView!
    
    let snapshot = Snapshot.sharedInstance
    
    var cvs = CustomVisionService()
    
    var finalPredictionResult = [CustomVisionPrediction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelOne.alpha = 0.1
        animateOne()
        
        print("Calling Custom Vision Service...")
        cvs.predict(image: snapshot.imageData!, completion: { (result: CustomVisionResult?, error: Error?) in
            DispatchQueue.main.async {
                if let error = error {
                    print("error: " + error.localizedDescription)
                } else if let result = result {
                    // (0%) proximity range get all results. HIGHER proximity range (e.g 90% -> 0.9) get result of HIGHER proximity.
                    let arr = self.cvs.filterProximityResults(proximityRangePercent: 0.9, result: result)
                    self.finalPredictionResult = arr
                    for value in arr {
                        let probabilityLabel = String(format: "%.1f", value.Probability * 100)
                        print("\(probabilityLabel)% sure this is \(value.Tag)")
                    }
                    self.performSegue(withIdentifier: "showMultipleResults", sender: nil)
                }
            }
        })
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavStatusBar(setting: [.blackStatusBar])

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateOne() {
        UIView.animate(withDuration: 1, animations: {
            self.bubbleOne?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.switchLabelAlpha()
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleOne?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.switchLabelAlpha()
            }) { (true) in
                self.animateTwo()
            }
        }
    }
    
    func animateTwo() {
        UIView.animate(withDuration: 1.5, animations: {
            self.bubbleTwo?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.switchLabelAlpha()
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleTwo?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.switchLabelAlpha()
            }) { (true) in
                self.animateThree()
            }
        }
    }
    
    func animateThree() {
        UIView.animate(withDuration: 1.5, animations: {
            self.bubbleThree?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.switchLabelAlpha()
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleThree?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.switchLabelAlpha()
            }) { (true) in
                self.animateOne()
            }
        }
    }
    
    func switchLabelAlpha() {
        if self.labelOne.alpha == 1 {
            self.labelOne.alpha = 0.1
        } else {
            self.labelOne.alpha = 1
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMultipleResults" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let mrc = destinationNavigationController.topViewController as! MultipleResultsController
            mrc.predictionData = self.finalPredictionResult
        }
    }


}
