//
//  RegViewControllerS3.swift
//  FoodIn
//
//  Created by Yuanxin Li on 4/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit

class RegViewControllerS3: UIViewController {

    let registration = Registration.sharedInstance
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var selectedDateOfBirth: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextBtnDidTap(_ sender: Any) {
        // Save input to registration singleton
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        selectedDateOfBirth = formatter.string(from: datePicker.date)
        registration.dob = selectedDateOfBirth
        print(registration.dob)
        
        // Proceed to next page
        performSegue(withIdentifier: "showRegS4", sender: nil)
    }
    
}
