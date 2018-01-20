//
//  FoodDetailsController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 26/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import KeychainSwift
import NVActivityIndicatorView

class FoodDetailsController: ButtonBarPagerTabStripViewController, NVActivityIndicatorViewable {

    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var suggestionBtn: UIButton!
    @IBOutlet weak var foodImage: UIImageView!
    
    var selectedFoodImage: UIImage?
    var selectedFoodName: String?
    static var selectedFood: Food?
    
    let snapshot = Snapshot.sharedInstance
    var pService = PersonService()
    var fService = FoodService()
    
    override func viewDidLoad() {
        
        // Note: setup tab bar before super.viewDidLoad
        setupTabBar()
        super.viewDidLoad()
        
        // Display title
        self.navigationItem.title = selectedFoodName
        
        // Display image
        foodImage.image = snapshot.image
        
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.whiteStatusBar, .whiteNavTitle, .whiteNavTint])
        
        // Customize Suggestion button
        setupSuggestionButton()
        
        // Display shadow overlay on the image
        setGradientBackground(colorOne: Colors.overlayShadowBlack, colorTwo: Colors.overlayShadowBlack)

        // Show activity indicator while retrieving data
        startAnimating(CGSize(width: 50, height: 50), type: .ballPulseSync, color: Colors.white)
        fService.getFoodDetails(foodName: selectedFoodName!, completion: { (result: Food?) in
            DispatchQueue.main.async {
                if let result = result {
                    print("retrieved food \(result)")
                    FoodDetailsController.selectedFood = result
                    NotificationCenter.default.post(name: Notification.Name(NotificationKey.foodData), object: nil)
                    self.stopAnimating()
                } else {
                    self.stopAnimating()
                    print("Empty or error")
                }
            }
        })
        
    }
    
    @IBAction func logFood(_ sender: Any) {
//        guard let id = Int(KeychainSwift().get("id")!) else { return }
//        let timestamp = UInt64(floor(Date().timeIntervalSince1970 * 1000))
//        pService.createFoodLog(personId: id, foodId: id, timestamp: timestamp,  completion: { (result: Int?) in
//            DispatchQueue.global().async {
//                if let result = result {
//                    print("create log result \(result)")
//                }
//            }
//        })
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.blackStatusBar, .greyNavTitle])
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        // Instantiate view controller for tab in tabs bar
        let nutrient = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nutrientChild")
        let vitamin = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vitaminChild")
        let mineral = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mineralChild")
        return [nutrient, vitamin, mineral]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.foodImage.frame
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        // Insert an overlay on top of food image
        self.foodImage.layer.insertSublayer(gradientLayer, above: foodImage.layer)
    }
    
    func setupSuggestionButton(){
        suggestionBtn.layer.cornerRadius = suggestionBtn.frame.size.height/2
        suggestionBtn.layer.shadowColor = UIColor.black.cgColor
        suggestionBtn.layer.shadowRadius = 2
        suggestionBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        suggestionBtn.layer.shadowOpacity = 0.3
    }
    
    func setupTabBar(){
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = Colors.pink
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 16)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = Colors.lightgrey
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        // Highlight active tab and remove highlight for inactive tab
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = Colors.lightgrey
            newCell?.label.textColor = Colors.pink
        }
    }
    
}

