//
//  ImageResultViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 25/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit

class ImageResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var predictionData:[PredictionResult] = []
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Results"

        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.blackStatusBar, .greyNavTitle])
        
        // Customize table border
        setupTableView()
        
        // Initialize the labels
        initLabels()
        
        
        tableView.addTopBorderWithColor(color: Colors.ghostwhite, width: 0.5)
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return predictionData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure cell
        cell.layoutMargins = UIEdgeInsets.zero
        cell.textLabel?.text = predictionData[indexPath.row].identifier
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
    
    func initLabels(){
        if predictionData.count == 1 {
            mainLabel.text = "Single Result Found"
            subLabel.text = "There's no other results that matches the snapshot"
        } else if predictionData.count > 1 {
            mainLabel.text = "Multiple Results Found"
            subLabel.text = "Please select the food that you think is the most likely one."
        } else if predictionData.count == 0 {
            mainLabel.text = "No Result Found"
            subLabel.text = "I coundn't find any results that matches the snapshot"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showFoodDetails"
        {
            let fdc = segue.destination as! FoodDetailsController
            if tableView.indexPathForSelectedRow != nil
            {
                let foodName = predictionData[tableView.indexPathForSelectedRow!.row].identifier
                fdc.selectedFoodName = foodName
            }
        }
    }

}
