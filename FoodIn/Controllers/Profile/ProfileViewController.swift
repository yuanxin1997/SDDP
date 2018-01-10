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
    var personIllness = [MyIllness]()

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    override func viewDidLoad() {
        table.tableFooterView = UIView()
        table.layoutMargins = UIEdgeInsets.zero
        table.separatorInset = UIEdgeInsets.zero
        table.separatorColor = Colors.ghostwhite
        setupCustomNavStatusBar(setting: [.showNavBar, .whiteNavTitle])
        personInfo = MyInfoService().getMyInfo()[0]
        personIllness = MyIllnessService().getMyIllness()
        nameLabel.text = personInfo!.name
        emailLabel.text = personInfo!.email
        ageLabel.text = String(calcAge(birthday: personInfo!.dob!))
        weightLabel.text = String(personInfo!.weight)
        heightLabel.text = String(personInfo!.height)
        print(personIllness[0].name!)
        print(personIllness.count)
        print(personInfo!.name!)
        print(personInfo!.email!)
        print(personInfo!.gender!)
        print(personInfo!.dob!)
        print(personInfo!.weight)
        print(personInfo!.height)
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
    }
    
    override func viewDidLayoutSubviews() {
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
        cell.illnessIndexLabel.text = "illness #\(indexPath.row + 1)"
        cell.illnessNameLabel.text = personIllness[indexPath.row].name!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @IBAction func didTapSignOutBtn(_ sender: Any) {
        KeychainSwift().clear()
        MyInfoService().clearMyInfo()
        MyIllnessService().clearMyIllness()
        MyIndicatorService().clearMyIndicator()
        
        Touch3D().disableQuickAction()
        
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
