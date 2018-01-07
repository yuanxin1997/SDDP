//
//  ProfileViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 7/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import KeychainSwift

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle])
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        // Do any additional setup after loading the view.
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func didTapSignOutBtn(_ sender: Any) {
        KeychainSwift().clear()
        MyInfoService().clearMyInfo()
        MyIllnessService().clearMyIllness()
        MyIndicatorService().clearMyIndicator()
        
        let welcomePage = self.storyboard?.instantiateViewController(withIdentifier: "welcomePage") as! WelcomeViewController
        let nav:UINavigationController = UINavigationController(rootViewController: welcomePage);
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = nav

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
