//
//  LandingViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 23/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var bubbleOne: UIImageView!
    @IBOutlet weak var bubbleTwo: UIImageView!
    @IBOutlet weak var bubbleThree: UIImageView!
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var labelTwo: UILabel!
    @IBOutlet weak var labelThree: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize landing page
        initLandingPage()
        
        // Customize button
        setupRegisterButton()
        
        // Start animation chaining
        animateOne()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        Registration.sharedInstance.clear()
        
        // Show UI component with fading effect
        UIView.animate(withDuration: 1) {
            self.registerBtn.alpha = 1
            self.loginBtn.alpha = 1
            self.bubbleOne.alpha = 1
            self.bubbleTwo.alpha = 1
            self.bubbleThree.alpha = 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.hideNavBar, .blackStatusBar])
    }
    
    func initLandingPage() {
        // hide all UI component
        registerBtn.alpha = 0
        loginBtn.alpha = 0
        bubbleOne.alpha = 0
        bubbleTwo.alpha = 0
        bubbleThree.alpha = 0
        labelOne.alpha = 0
        labelTwo.alpha = 0
        labelThree.alpha = 0
    }
    
    func setupRegisterButton() {
        registerBtn.layer.cornerRadius = registerBtn.frame.size.height/2
        registerBtn.layer.masksToBounds = true
    }
    
    // First element in animation chaining
    func animateOne() {
        UIView.animate(withDuration: 1.5, animations: {
            self.bubbleOne?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.labelOne.alpha = 1
            self.labelTwo.alpha = 0.1
            self.labelThree.alpha = 0.1
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleOne?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (true) in
                self.animateTwo()
            }
        }
    }
    
    // Second element in animation chaining
    func animateTwo() {
        UIView.animate(withDuration: 1.5, animations: {
            self.bubbleTwo?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.labelOne.alpha = 0.1
            self.labelTwo.alpha = 1
            self.labelThree.alpha = 0.1
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleTwo?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (true) in
                self.animateThree()
            }
        }
    }
    
    // Third element in animation chaining
    func animateThree() {
        UIView.animate(withDuration: 1.5, animations: {
            self.bubbleThree?.transform = CGAffineTransform(scaleX: 2, y: 2)
            self.labelOne.alpha = 0.1
            self.labelTwo.alpha = 0.1
            self.labelThree.alpha = 1
        }) { (true) in
            UIView.animate(withDuration: 1.5, animations: {
                self.bubbleThree?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }) { (true) in
                self.animateOne()
            }
        }
    }
    
}

