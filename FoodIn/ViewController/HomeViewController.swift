//
//  HomeViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 23/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var center: UIImageView!
    @IBOutlet weak var left: UIImageView!
    @IBOutlet weak var top: UIImageView!
    @IBOutlet weak var right: UIImageView!
    
    @IBOutlet weak var greetingLabel: UILabel!
    
    var centerOrigin: CGPoint!
     var inspectOption: String!
     var timer = Timer()
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for element in MyInfoService().getMyInfo() {
            print("printing \(element.name) ")
        }
        
        for element in MyIllnessService().getMyIllness() {
            print("printing \(element.name) ")
        }
        
        for element in MyIndicatorService().getMyIndicator() {
            print("printing \(element.name) ")
        }
       //print("printing \(MyInfoService().getMyInfo()[0].name) ")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.addPulse()
        }
    }
    
    override func viewDidLayoutSubviews() {
        centerOrigin = center.frame.origin
        setGradientBackground(colorOne:Colors.pink , colorTwo: Colors.red)
    }
    
    override func viewWillAppear(_ animated: Bool) {
         setupCustomNavStatusBar(setting: [.hideNavBar, .whiteStatusBar])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addPulse(){
        let pulse = Pulsing(numberOfPulses: 1, radius: 110, position: center.center)
        pulse.animationDuration = 1.5
        pulse.backgroundColor = Colors.white.cgColor
        self.view.layer.insertSublayer(pulse, below: center.layer)
    }

    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let gPoint = recognizer.view!
        
        switch recognizer.state {
        case .began, .changed:
            moveViewWithPan(view: gPoint, sender: recognizer)
            
        case .ended:
            if gPoint.frame.intersects(top.frame)
            {
                touchedView(view: gPoint, inspectOption: "Nutritional Label")
                print("touched")
                
            }
            else if gPoint.frame.intersects(left.frame)
            {
                touchedView(view: gPoint, inspectOption: "Food Menu")
                print("touched")
            }
            else if gPoint.frame.intersects(right.frame)
            {
                touchedView(view: gPoint, inspectOption: "Food Item")
                print("touched")
            }
            else
            {
                returnViewToOrigin(view: gPoint)
            }
            
        default:
            break
        }
    }
    
    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        guard center.frame.intersects(top.frame) || center.frame.intersects(left.frame) || center.frame.intersects(right.frame) else {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
            return
        }
    }
    
    func returnViewToOrigin(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.frame.origin = self.centerOrigin
        })
    }
    
    func touchedView(view: UIView, inspectOption: String) {
        UIView.animate(withDuration: 0.5, animations: {
            self.inspectOption = inspectOption
            view.frame.origin = self.centerOrigin
        }) { (true) in
            self.performSegue(withIdentifier: "showCamera", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCamera" {
            let cvc = segue.destination as! CameraViewController
            cvc.inspectOption = self.inspectOption
        }
    }

}
