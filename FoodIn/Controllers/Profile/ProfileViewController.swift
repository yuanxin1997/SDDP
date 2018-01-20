//
//  ProfileViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 7/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import KeychainSwift

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var personInfo: MyInfo?
    var personIllness:[MyIllness] = []
    let myInfoService = MyInfoService()

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Display title
        self.navigationItem.title = "Profile"
        
        // Initialize
        initProfile()
        initTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.showNavBar, .whiteNavTitle])
    }
    
    override func viewDidLayoutSubviews() {
        // Customize the profile view with gradient color
        setGradientBackground(colorOne:Colors.pink , colorTwo: Colors.red)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personIllness.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IllnessTag
       
        // Configure cell
        cell.illnessIndexLabel.text = "illness #\(indexPath.row + 1)"
        cell.illnessNameLabel.text = personIllness[indexPath.row].name!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func didTapSignOutBtn(_ sender: Any) {
        // Clear keychain and local data
        KeychainSwift().clear()
        MyInfoService().clearMyInfo()
        MyIllnessService().clearMyIllness()
        MyIndicatorService().clearMyIndicator()
        
        // Enable 3D touch feature after sign in
        Touch3D().disableQuickAction()
        
        // Change rootview to HomePage
        goToLandingPage()
    }
    
    func initProfile() {
        // Retrieve data locally
        personInfo = MyInfoService().getMyInfo()[0]
        personIllness = MyIllnessService().getMyIllness()
        
        // Pass in values
        nameLabel.text = personInfo!.name
        emailLabel.text = personInfo!.email
        ageLabel.text = String(calcAge(birthday: personInfo!.dob!)) // Calculate age using data of birth
        weightLabel.text = String(personInfo!.weight)
        heightLabel.text = String(personInfo!.height)
    }
    
    func initTable() {
        table.tableFooterView = UIView()
        table.layoutMargins = UIEdgeInsets.zero
        table.separatorInset = UIEdgeInsets.zero
        table.separatorColor = Colors.ghostwhite
    }
    
    func goToLandingPage(){
        let landingPage = self.storyboard?.instantiateViewController(withIdentifier: "landingPage") as! LandingViewController
        let nav:UINavigationController = UINavigationController(rootViewController: landingPage);
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = nav
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = profileView.bounds
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        profileView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }

}
