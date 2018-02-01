//
//  CustomNavBar.swift
//  FoodIn
//
//  Created by Yuanxin Li on 1/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import UIKit

public enum navSettings {
    case hideNavBar
    case showNavBar
    case hideStatusBar
    case showStatusBar
    case whiteStatusBar
    case blackStatusBar
    case greyNavTitle
    case whiteNavTitle
    case greyNavTint
    case whiteNavTint
    case pinkNavTintBar
}

extension UIViewController {
    public func setupCustomNavStatusBar(setting: Set<navSettings>) {
        
        // Default custom configuration
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "BackButton")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "BackButton")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        switch setting {
        case [.hideNavBar]:
            navigationController?.setNavigationBarHidden(true, animated: false)
        case [.showNavBar]:
            navigationController?.setNavigationBarHidden(false, animated: false)
        case [.showStatusBar]:
            UIApplication.shared.isStatusBarHidden = false
        case [.hideStatusBar]:
            UIApplication.shared.isStatusBarHidden = true
        case [.showNavBar, .whiteStatusBar]:
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            UIApplication.shared.statusBarStyle = .lightContent
        case [.showNavBar, .blackStatusBar]:
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            UIApplication.shared.statusBarStyle = .default
        case [.hideNavBar, .whiteStatusBar]:
            navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.statusBarStyle = .lightContent
        case [.hideNavBar, .blackStatusBar]:
            navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.statusBarStyle = .default
        case [.hideNavBar, .hideStatusBar]:
            navigationController?.setNavigationBarHidden(true, animated: false)
            UIApplication.shared.isStatusBarHidden = true
        case [.showNavBar, .showStatusBar]:
            navigationController?.setNavigationBarHidden(false, animated: false)
            UIApplication.shared.isStatusBarHidden = false
        case [.blackStatusBar, .greyNavTitle]:
            UIApplication.shared.statusBarStyle = .default
            navigationController?.navigationBar.tintColor = Colors.darkgrey
            navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: Colors.darkgrey, NSAttributedStringKey.font: Fonts.Regular.of(size: 20)]
        case [.whiteStatusBar, .whiteNavTitle, .whiteNavTint]:
            UIApplication.shared.statusBarStyle = .lightContent
            navigationController?.navigationBar.tintColor = Colors.white
            navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: Colors.white, NSAttributedStringKey.font: Fonts.Regular.of(size: 20)]
        case [.showNavBar, .greyNavTitle]:
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.navigationBar.tintColor = Colors.darkgrey
            navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: Colors.darkgrey, NSAttributedStringKey.font: Fonts.Regular.of(size: 20)]
        case [.showNavBar, .whiteNavTitle]:
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.navigationBar.tintColor = Colors.white
//            navigationController?.navigationBar.setBackgroundImage(UIImage(color: Colors.pink), for: .default)
            navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: Colors.white, NSAttributedStringKey.font: Fonts.Regular.of(size: 20)]
        case [.showNavBar, .whiteNavTitle, .pinkNavTintBar]:
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.navigationBar.tintColor = Colors.white
            navigationController?.navigationBar.barTintColor = Colors.pink
            navigationController?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.foregroundColor: Colors.white, NSAttributedStringKey.font: Fonts.Regular.of(size: 20)]
        default:
            UIApplication.shared.isStatusBarHidden = false
            UIApplication.shared.statusBarStyle = .default
            navigationController?.navigationBar.tintColor = Colors.darkgrey
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        
    }
    
}


