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

    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Save input to registration singleton
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        selectedDateOfBirth = formatter.string(from: datePicker.date)
        registration.dob = selectedDateOfBirth
        print(registration.dob)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
