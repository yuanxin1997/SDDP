//
//  avoidListViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 25/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class avoidListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider {
    
    var avoidFoodNameArray:[Food] = []
    var filteredFoodNameArray:[Food] = []
    let extractedTextArray = ExtractedTextArray.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        filteredFoodNameArray = extractedTextArray.objectArray!
        
        
        for food in filteredFoodNameArray {
            if food.sodium > 1500 {
                avoidFoodNameArray.append(food)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return avoidFoodNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure cell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.textLabel?.text = avoidFoodNameArray[indexPath.row].name
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
        return IndicatorInfo(title: "Avoid")
    }

}
