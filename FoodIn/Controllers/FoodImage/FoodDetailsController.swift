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
import AMPopTip

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
    let popTip = PopTip()
    
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
        
        // Custom Tool Tip
        setupToolTip()
        
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
                    if result.sodium < 1500 {
                        self.determineSafeOrAvoid(suggestion: "Safe")
                    } else {
                        self.determineSafeOrAvoid(suggestion: "Avoid")
                    }
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
    
    @IBAction func suggestionBtnDidTap(_ sender: Any) {
        showToolTip()
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
    
    func setupToolTip() {
        popTip.font = Fonts.Regular.of(size: 12)
        popTip.bubbleColor = Colors.white
        popTip.textColor = Colors.lightgrey
        popTip.shouldDismissOnTap = true
        popTip.shouldDismissOnTapOutside = true
        popTip.shouldDismissOnSwipeOutside = true
        popTip.edgeMargin = 5
        popTip.offset = 5
        popTip.bubbleOffset = 0
        popTip.actionAnimation = .pulse(1.1)
        popTip.edgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
    func setupSuggestionButton(){
        suggestionBtn.alpha = 0.0
        suggestionBtn.layer.cornerRadius = suggestionBtn.frame.size.height/2
        suggestionBtn.layer.shadowColor = UIColor.black.cgColor
        suggestionBtn.layer.shadowRadius = 2
        suggestionBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        suggestionBtn.layer.shadowOpacity = 0.3
    }
    
    func determineSafeOrAvoid(suggestion: String){
        suggestionBtn.alpha = 1.0
        suggestionBtn.setTitle(suggestion ,for: .normal)
        showToolTip()
        if suggestion == "Safe" {
            suggestionBtn.backgroundColor = Colors.green
        } else if suggestion == "avoid" {
            suggestionBtn.backgroundColor = Colors.red
        }
    }
    
    func showToolTip() {
        popTip.show(text: "The sodium level has hit your limit", direction: .up, maxWidth: (suggestionBtn.frame.width * 1.5), in: view, from: suggestionBtn.frame)
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

