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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        highlight(gender: "male")
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle]);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        registration.gender = selectedGender
        print(registration.gender)
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
        maleButton.layer.shadowColor = UIColor.black.cgColor
        maleButton.layer.shadowRadius = 7
        maleButton.layer.shadowOffset = CGSize(width: 7, height: 7)
        maleButton.layer.shadowOpacity = 0.4
        
        femaleButton.layer.shadowColor = UIColor.black.cgColor
        femaleButton.layer.shadowRadius = 3
        femaleButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        femaleButton.layer.shadowOpacity = 0.1
    }
    
    func highlightFemaleButton(){
        femaleButton.layer.shadowColor = UIColor.black.cgColor
        femaleButton.layer.shadowRadius = 7
        femaleButton.layer.shadowOffset = CGSize(width: 7, height: 7)
        femaleButton.layer.shadowOpacity = 0.4
        
        maleButton.layer.shadowColor = UIColor.black.cgColor
        maleButton.layer.shadowRadius = 3
        maleButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        maleButton.layer.shadowOpacity = 0.1
    }

}
