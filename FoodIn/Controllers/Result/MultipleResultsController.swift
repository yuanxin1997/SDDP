//
//  MultipleResultsController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 24/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit

class MultipleResultsController: UITableViewController {

    
    @IBOutlet weak var headView: UIView!
    
    var predictionData: [CustomVisionPrediction] = []
    
    override func viewDidLoad() {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.blackStatusBar, .greyNavTitle])
        super.viewDidLoad()
        
        // Customize table border
        tableView.tableFooterView = UIView()
        tableView.layoutMargins = UIEdgeInsets.zero
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = Colors.ghostwhite
        
        // Add bottom border to head view
        headView.addBottomBorderWithColor(color: Colors.ghostwhite, width: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return predictionData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.textLabel?.text = predictionData[indexPath.row].Tag
        cell.textLabel?.textColor = Colors.darkgrey
        let chevron = UIImage(named: "Chevron")
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = UIImageView(image: chevron!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showFoodDetailstTwo"
        {
            let fdc = segue.destination as! FoodDetailsController
            if tableView.indexPathForSelectedRow != nil
            {
                let foodName = predictionData[tableView.indexPathForSelectedRow!.row].Tag
                fdc.selectedFoodName = foodName
            }
        }
    }
    
}



