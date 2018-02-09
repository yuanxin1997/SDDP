//
//  safeListViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 25/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import KeychainSwift

class fullMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
    var fullMenuArray:[Food] = []
    let extractedTextArray = ExtractedTextArray.sharedInstance
    let extractedSafeArray = ExtractedSafeArray.sharedInstance
    var pService = PersonService()
    var arrayOfNutritionalOverLimit:[String] = []
    var safe:Int = 0
    var arrayofsafe:[Int] = []
    var datatec:Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fullMenuArray = extractedTextArray.objectArray!
        
        print("THIS IS THE FULL ZONE")
        print(fullMenuArray)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure cell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.textLabel?.text = fullMenuArray[indexPath.row].name
        cell.textLabel?.textColor = Colors.darkgrey
        let chevron = UIImage(named: "Chevron")
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: chevron!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = Colors.ghostwhite
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Menu")
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "MenuSegue"
        {
            let fdc = segue.destination as! ResultMenuViewController
            if tableView.indexPathForSelectedRow != nil
            {
                let foodName = fullMenuArray[tableView.indexPathForSelectedRow!.row]
                fdc.selectedFood = foodName
            }
        }
        
    }
    
}

