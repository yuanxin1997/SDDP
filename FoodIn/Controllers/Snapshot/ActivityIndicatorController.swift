//
//  ActivityIndicatorController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 26/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import Vision

class ActivityIndicatorController: UIViewController {

    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var bubbleOne: UIImageView!
    @IBOutlet weak var bubbleTwo: UIImageView!
    @IBOutlet weak var bubbleThree: UIImageView!
    
    let snapshot = Snapshot.sharedInstance
    var finalPredictionResult: [PredictionResult] = []
    let icService = ImageClassificationService()
    
    lazy var classificationRequest: [VNRequest] = {
        do {
            // Load the Custom Vision model.
            // To add a new model, drag it to the Xcode project browser making sure that the "Target Membership" is checked.
            // Then update the following line with the name of your new model.
            let model = try VNCoreMLModel(for: FoodIn().model)
            let classificationRequest = VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
            classificationRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.centerCrop
            
            return [ classificationRequest ]
        } catch {
            fatalError("Can't load Vision ML model: \(error)")
        }
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelOne.alpha = 0.1
        
        // Start animation chaining
        animateOne()
        
        // Get food name from prediction
        predictFoodItem()
    }

    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.blackStatusBar])

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func predictFoodItem() {
        do {
            let classifierRequestHandler = VNImageRequestHandler(cgImage: (snapshot.image?.cgImage)!, options: [:])
            try classifierRequestHandler.perform(classificationRequest)
        } catch {
            print(error)
        }
    }
    
    // First element in animation chaining
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
    
    // Second element in animation chaining
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
    
    // Third element in animation chaining
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
    
    // Fading animation for label
    func switchLabelAlpha() {
        if self.labelOne.alpha == 1 {
            self.labelOne.alpha = 0.1
        } else {
            self.labelOne.alpha = 1
        }
    }
    
    // Handle image classification results
    func handleClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation] else { fatalError("unexpected result type from VNCoreMLRequest") }
        icService.printAllResults(observations: observations)
        // First filter based on minimum confidence level
        // Then by filter by proximity range
        // (0%) proximity range get all results. HIGHER proximity range (e.g 90% -> 0.9) get result of HIGHER proximity.
        icService.filterProximityResults(proximityRangePercent: 0.9, minimumConfidence: 0.0, observations: observations, completion: { (result: [PredictionResult]?) in
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
                if let result = result {
                    self.finalPredictionResult = result
                    self.performSegue(withIdentifier: "showMultipleResults", sender: nil)
                    print(result)
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showMultipleResults" {
            let destinationNavigationController = segue.destination as! UINavigationController
            let mrc = destinationNavigationController.topViewController as! MultipleResultsController
            mrc.predictionData = self.finalPredictionResult
        }
    }


}
