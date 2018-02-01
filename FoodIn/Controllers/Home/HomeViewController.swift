//
//  HomeViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 23/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import KeychainSwift

class HomeViewController: UIViewController {
    
    @IBOutlet weak var center: UIImageView!
    @IBOutlet weak var left: UIImageView!
    @IBOutlet weak var top: UIImageView!
    @IBOutlet weak var right: UIImageView!
    
    @IBOutlet weak var askBtn: UIButton!
    
    @IBOutlet weak var greetingLabel: UILabel!
    let inspectionMode = InspectionMode.sharedInstance
    
    var centerOrigin: CGPoint!
    var timer = Timer()
    
    let pService = PersonService()
    let fService = FoodService()
    
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAskBtn()
//
//        // Retrieve data locally and pass in the value
        if let greetingName = MyInfoService().getMyInfo()[0].name {
            greetingLabel.text = "Hi, \(MyInfoService().getMyInfo()[0].name!)."
        }
        let myInfo = MyInfoService().getMyInfo()[0]
        let myIndicator = MyIndicatorService().getMyIndicator()
        var myRS = RecommendationStandard(info: myInfo).with(indicator: myIndicator)
        print(myRS.carbohydrate)
        // Testing
        for element in MyInfoService().getMyInfo() {
            print("printing \(element.name) ")
        }

        for element in MyIllnessService().getMyIllness() {
            print("printing \(element.name) ")
        }

        for element in MyIndicatorService().getMyIndicator() {
            print("printing \(element.name) ")
        }
        
        
        getPersonFoodLog()

//                KeychainSwift().clear()
//                MyInfoService().clearMyInfo()
//                MyIllnessService().clearMyIllness()
//                MyIndicatorService().clearMyIndicator()
        //print("printing \(MyInfoService().getMyInfo()[0].name) ")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Repeat the pulse effect every 0.5 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.addPulse()
        }
    }
    
    override func viewDidLayoutSubviews() {
        // Remember its original position
        centerOrigin = center.frame.origin
        setGradientBackground(colorOne:Colors.pink , colorTwo: Colors.red)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.hideNavBar, .whiteStatusBar])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Stop the repeating the pulsing animation after dissapear
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAskBtn() {
        askBtn.layer.cornerRadius = askBtn.frame.size.height/5
    }
    
    // Add floating effect to the camera icon
    func addPulse(){
        let pulse = Pulsing(numberOfPulses: 1, radius: 110, position: center.center)
        pulse.animationDuration = 1.5
        pulse.backgroundColor = Colors.white.cgColor
        self.view.layer.insertSublayer(pulse, below: center.layer)
    }
    
    // Customize the home page with gradient color
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
                touchedView(view: gPoint, inspectMode: "Food Menu")
                print("touched")
                
            }
            else if gPoint.frame.intersects(left.frame)
            {
                touchedView(view: gPoint, inspectMode: "Food Label")
                print("touched")
            }
            else if gPoint.frame.intersects(right.frame)
            {
                touchedView(view: gPoint, inspectMode: "Food Item")
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
    
    // Allow camera icon to follow your gesture movement
    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        guard center.frame.intersects(top.frame) || center.frame.intersects(left.frame) || center.frame.intersects(right.frame) else {
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
            return
        }
    }
    
    // Return to origional position after release
    func returnViewToOrigin(view: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            view.frame.origin = self.centerOrigin
        })
    }
    
    // Open camera when hit any of the arc
    func touchedView(view: UIView, inspectMode: String) {
        UIView.animate(withDuration: 0.5, animations: {
            self.inspectionMode.mode = inspectMode
            view.frame.origin = self.centerOrigin
        }) { (true) in
            self.performSegue(withIdentifier: "showCamera", sender: self)
        }
    }
    
    func getPersonFoodLog() {
        
        
        guard let id = Int(KeychainSwift().get("id")!) else { return }
        print("my id is \(id)")
        let to = UInt64(floor(Date().timeIntervalSince1970))
        let from = UInt64(floor(Date().startOfDay.timeIntervalSince1970))
        print(to)
        print(from)
        
        let myIndicator = MyIndicatorService().getMyIndicator()
        for i in myIndicator {
            print(i.name)
        }

        pService.getFoodLog(personId: id, from: from, to: to, completion: { (result: [Food]?) in
            if let result = result {
                for i in result {
                    print(i.sodium)
                }
                print("\(result.count) results today")
            }
        })
    }
    
}


