//
//  menuDetailsViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 25/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class menuDetailsViewController: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        
        // Display title
        self.navigationItem.title = "Results"
        
        setupTabBar()
        
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavStatusBar(setting: [.blackStatusBar, .greyNavTitle])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTabBar(){
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.whiteStatusBar, .whiteNavTitle, .whiteNavTint])
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = Colors.pink
        settings.style.buttonBarItemFont = Fonts.Regular.of(size: 16)
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
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let Safe = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "safeList")
        let Avoid = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "avoidList")
        return [Safe, Avoid]
    }

}
