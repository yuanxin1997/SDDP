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

class FoodDetailsController: ButtonBarPagerTabStripViewController {

    @IBOutlet weak var logBtn: UIButton!
    @IBOutlet weak var suggestionBtn: UIButton!
    @IBOutlet weak var foodImage: UIImageView!
    var selectedFoodImage: UIImage?
    var selectedFoodName: String?
    
    static var selectedFood: Food?
    static var parentFoodName: String?
    
    let snapshot = Snapshot.sharedInstance
    var pService = PersonService()
    var fService = FoodService()
    
    override func viewDidLoad() {
        guard let selectedFoodName = selectedFoodName else { return }
        fService.getFoodDetails(foodName: selectedFoodName, completion: { (result: Food?) in
            DispatchQueue.main.async {
                if let result = result {
                    print("retrieved food \(result)")
                    FoodDetailsController.selectedFood = result
                }
            }
        })
        foodImage.image = snapshot.image
        
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.whiteStatusBar, .whiteNavTitle, .whiteNavTint])

        FoodDetailsController.parentFoodName = selectedFoodName
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
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = Colors.lightgrey
            newCell?.label.textColor = Colors.pink
        }
        
        super.viewDidLoad()
        
        setupSuggestionButton()
        setGradientBackground(colorOne: Colors.overlayShadowBlack, colorTwo: Colors.overlayShadowBlack)
        
        self.navigationItem.title = selectedFoodName
        
    }
    
    @IBAction func logFood(_ sender: Any) {
        guard let id = Int(KeychainSwift().get("id")!) else { return }
        guard let food = FoodDetailsController.selectedFood else { return }
        print("logging food \(food)")
        let timestamp = UInt64(floor(Date().timeIntervalSince1970))
        pService.createFoodLog(personId: id, foodId: food.id, timestamp: timestamp,  completion: { (result: Dictionary<String, Int>?) in
            DispatchQueue.global().async {
                if let result = result {
                    guard let status = result["message"] else {
                        print("log food response error \(result)")
                        return
                    }
                    print("create log result \(status)")
                }
            }
        })
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.blackStatusBar, .greyNavTitle])
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let nutrient = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "nutrientChild")
        let vitamin = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vitaminChild")
        let mineral = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mineralChild")
        return [nutrient, vitamin, mineral]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Customize food image view with overlay later
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.foodImage.frame
        gradientLayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.foodImage.layer.insertSublayer(gradientLayer, above: foodImage.layer)
    }
    
    // Customize suggestion button
    func setupSuggestionButton(){
        suggestionBtn.layer.cornerRadius = suggestionBtn.frame.size.height/2
        suggestionBtn.layer.shadowColor = UIColor.black.cgColor
        suggestionBtn.layer.shadowRadius = 2
        suggestionBtn.layer.shadowOffset = CGSize(width: 2, height: 2)
        suggestionBtn.layer.shadowOpacity = 0.3
    }
}

