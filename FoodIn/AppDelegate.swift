//
//  AppDelegate.swift
//  FoodIn
//
//  Created by Yuanxin Li on 17/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KeychainSwift
import ApiAI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let inspectionMode = InspectionMode.sharedInstance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Configure the client access token
        let configuration = AIDefaultConfiguration()
        configuration.clientAccessToken = "e09d039919a14f88a340e36cbca6d46c"
        
        // Allow configuration of dialog flow
        let apiai = ApiAI.shared()
        apiai?.configuration = configuration
        
        // Allow this keyboard manager library
        IQKeyboardManager.sharedManager().enable = true
        
        // Fade In
        Thread.sleep(forTimeInterval: 1.0)
        
        // Set the user default if there is not exists
        let defaults = UserDefaults.standard
        if !defaults.contains(key: "VoiceUITheme") {
            defaults.set("Light", forKey: "VoiceUITheme")
        }
        
        //  Get person ID from keychain
        if let personId = KeychainSwift().get("id") {
            // Take user to a home page
            let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homePage = mainStoryboard.instantiateViewController(withIdentifier: "homePage") as! HomeViewController
            let nav:UINavigationController = UINavigationController(rootViewController: homePage)
            self.window?.rootViewController = nav
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        PersistenceService.saveContext()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        // Get root navigation viewcontroller and its first controller
        let rootNavigationViewController = window!.rootViewController as? UINavigationController
        let rootViewController = rootNavigationViewController?.viewControllers.first as UIViewController?
        
        if shortcutItem.type == "com.yuanxin.FoodIn.askFoodInspector" {
            // Pop to root view controller so that approperiete segue can be performed
            rootNavigationViewController?.popToRootViewController(animated: false)
            rootViewController?.performSegue(withIdentifier: "showSpeech", sender: nil)
        } else {
            if shortcutItem.type == "com.yuanxin.FoodIn.snapFoodLabel" {
                inspectionMode.mode = "Food Label"
            } else if shortcutItem.type == "com.yuanxin.FoodIn.snapFoodMenu" {
                inspectionMode.mode = "Food Menu"
            } else if shortcutItem.type == "com.yuanxin.FoodIn.snapFoodItem" {
                inspectionMode.mode = "Food Item"
            }
            // Pop to root view controller so that approperiete segue can be performed
            rootNavigationViewController?.popToRootViewController(animated: false)
            rootViewController?.performSegue(withIdentifier: "showCamera", sender: nil)
        }
        
        completionHandler(true)
    }

}


