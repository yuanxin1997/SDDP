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

class LabelDetailsController: ButtonBarPagerTabStripViewController, NVActivityIndicatorViewable {
    
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
    var arrayOfNutritionalOverLimit:[String] = []
    
    override func viewDidLoad() {
        
        // Note: setup tab bar before super.viewDidLoad
        setupTabBar()
        super.viewDidLoad()
        
        // Display title
        self.navigationItem.title = "Food Label"
        
        // Display image
        if let image = snapshot.image {
            foodImage.image = image
        }
        
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.whiteStatusBar, .whiteNavTitle, .whiteNavTint])
        
        // Custom Tool Tip
        setupToolTip()
        
        // Customize Suggestion button
        setupSuggestionButton()
        
        // Display shadow overlay on the image
        setGradientBackground(colorOne: Colors.overlayShadowBlack, colorTwo: Colors.overlayShadowBlack)
        
        // Show activity indicator while retrieving data

        NotificationCenter.default.post(name: Notification.Name(NotificationKey.labelData), object: nil)
        
    }
    
    @IBAction func logFood(_ sender: Any) {
        
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
        let nutrient = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "labelNutrientChild")
        let vitamin = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "labelVitaminChild")
        let mineral = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "labelMineralChild")
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
        popTip.offset = 2
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
    
    func determineSafeOrAvoid(){
        suggestionBtn.alpha = 1.0
        if arrayOfNutritionalOverLimit.count > 0 {
            suggestionBtn.setTitle("avoid" ,for: .normal)
            suggestionBtn.backgroundColor = Colors.red
        } else {
            suggestionBtn.setTitle("safe" ,for: .normal)
            suggestionBtn.backgroundColor = Colors.green
        }
    }
    
    func showToolTip() {
        var finalText = ""
        if arrayOfNutritionalOverLimit.count > 0 {
            let text = arrayOfNutritionalOverLimit.reduce("", { $0 == "" ? $1 : $0 + ", " + $1 })
            finalText = "The \(text) level has hit your limit"
        } else {
            finalText = "None of its nutritional value will hit your limit"
        }
        popTip.show(text: finalText, direction: .up, maxWidth: (suggestionBtn.frame.width * 1.5), in: view, from: suggestionBtn.frame)
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
    
    func inspectFood(food: Food) {
        guard let id = Int(KeychainSwift().get("id")!) else { return }
        let to = UInt64(floor(Date().timeIntervalSince1970))
        let from = UInt64(floor(Date().startOfDay.timeIntervalSince1970))
        pService.getFoodLog(personId: id, from: from, to: to, completion: { (result: [FoodLog]?) in
            DispatchQueue.main.async {
                if let result = result {
                    let myIndicator = MyIndicatorService().getMyIndicator()
                    let foodMirror = Mirror(reflecting: food)
                    for (name, value) in foodMirror.children {
                        for i in myIndicator {
                            if name == i.name {
                                let valueToMatch = value as! Double
                                if self.getTotalValueFromLog(foods: result, indicatorName: i.name!, currentNutritionValue: valueToMatch) > i.maxValue {
                                    self.arrayOfNutritionalOverLimit.append(name!)
                                }
                                print(self.getTotalValueFromLog(foods: result, indicatorName: i.name!, currentNutritionValue: valueToMatch))
                            }
                        }
                    }
                    self.determineSafeOrAvoid()
                    self.showToolTip()
                }
                print(result)
            }
        })
    }
    
    func getTotalValueFromLog(foods: [FoodLog], indicatorName: String, currentNutritionValue: Double) -> Double {
        var totalValue = currentNutritionValue
        for food in foods {
            let foodMirror = Mirror(reflecting: food)
            for (name, value) in foodMirror.children {
                if name == indicatorName {
                    let valueToSum = value as! Double
                    print(valueToSum)
                    totalValue += valueToSum
                    print(totalValue)
                }
            }
        }
        return totalValue
    }
    
}


