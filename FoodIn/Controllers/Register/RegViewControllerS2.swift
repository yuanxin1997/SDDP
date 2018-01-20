//
//  RegViewControllerS2.swift
//  FoodIn
//
//  Created by Yuanxin Li on 4/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit

class RegViewControllerS2: UIViewController {
    
    let registration = Registration.sharedInstance
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    
    var selectedGender: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set default selection to male
        highlight(gender: "male")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle]);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func maleDidSelected(_ sender: Any) {
        highlight(gender: "male")
    }
    
    @IBAction func femaleDidSelected(_ sender: Any) {
        highlight(gender: "female")
    }
    
    func highlight(gender: String){
        selectedGender = gender
        switch gender {
        case "male":
            highlightMaleButton()
        case "female":
            highlightFemaleButton()
        default:
            highlightMaleButton()
        }
    }
    
    func highlightMaleButton(){
        // Higlight male button
        maleButton.layer.shadowColor = UIColor.black.cgColor
        maleButton.layer.shadowRadius = 7
        maleButton.layer.shadowOffset = CGSize(width: 7, height: 7)
        maleButton.layer.shadowOpacity = 0.4
        
        // Remove highlight for female button
        femaleButton.layer.shadowColor = UIColor.black.cgColor
        femaleButton.layer.shadowRadius = 3
        femaleButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        femaleButton.layer.shadowOpacity = 0.1
    }
    
    func highlightFemaleButton(){
        // Highlight female button
        femaleButton.layer.shadowColor = UIColor.black.cgColor
        femaleButton.layer.shadowRadius = 7
        femaleButton.layer.shadowOffset = CGSize(width: 7, height: 7)
        femaleButton.layer.shadowOpacity = 0.4
        
        // Remove highlight for male button
        maleButton.layer.shadowColor = UIColor.black.cgColor
        maleButton.layer.shadowRadius = 3
        maleButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        maleButton.layer.shadowOpacity = 0.1
    }

    @IBAction func nextBtnDidTap(_ sender: Any) {
        // Save input to registration singleton
        registration.gender = selectedGender
        print(registration.gender)
        
        // Proceed to next page
        performSegue(withIdentifier: "showRegS3", sender: nil)
    }
    
}
