//
//  RegViewControllerS5.swift
//  FoodIn
//
//  Created by Yuanxin Li on 4/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class RegViewControllerS5: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NVActivityIndicatorViewable {
    
    var iService = IllnessService()
    var illnessList:[Illness] = []
    var filteredIllnessList:[Illness] = []
    var selectedIllnessArr:[Illness] = []
    let registration = Registration.sharedInstance
    

    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize
        initTable()
        initSearchBar()
        initNextBtn()
        
        // Get list of illness from database
        getListOfIllness()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle]);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredIllnessList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IllnessCheckbox
        
        cell.illnessLabel.text = filteredIllnessList[indexPath.row].name
        cell.illnessId = filteredIllnessList[indexPath.row].id
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let tempArr = selectedIllnessArr.filter{$0.id == cell.illnessId}
        if tempArr.count > 0 {
            cell.checkBox.on = true
        } else {
            cell.checkBox.on = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func initTable() {
        table.tableFooterView = UIView()
        table.layoutMargins = UIEdgeInsets.zero
        table.separatorInset = UIEdgeInsets.zero
        table.separatorColor = Colors.ghostwhite
    }
    
    func initSearchBar() {
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.alpha = 0
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = Colors.darkgrey
            textField.backgroundColor = Colors.ghostwhite
            textField.font = Fonts.Regular.of(size: 16)
        }
    }
    
    func initNextBtn(){
        // Disable next button
        nextBtn.isEnabled = false
        nextBtn.alpha = 0
    }
    
    func getListOfIllness() {
        // Show activity indicator
        startAnimating(CGSize(width: 50, height: 50), type: .ballPulseSync, color: Colors.white)
        
        // Get list of illness from database
        iService.getIllnessList (completion: { (result: [Illness]?) in
            DispatchQueue.main.async {
                if let result = result {
                    self.stopAnimating()
                    self.illnessList = result
                    self.filteredIllnessList = self.illnessList
                    print(self.illnessList)
                    self.table.reloadData()
                    self.searchBar.alpha = 1
                    self.nextBtn.alpha = 0.5
                } else {
                    self.stopAnimating()
                    print("Empty or error")
                }
            }
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredIllnessList is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredIllnessList = searchText.isEmpty ? illnessList : illnessList.filter { (item: Illness) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        table.reloadData()
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Hide keyboard when return button is pressed
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        table.isUserInteractionEnabled = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        table.isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Hide keyboard when touches any where on the screen
        searchBar.endEditing(true)
    }
    
    @IBAction func didToggle(_ sender: Any) {
        var position = (sender as AnyObject).convert(CGPoint.zero, to: table)
        if let indexPath = table.indexPathForRow(at: position) {
            var cell = table.cellForRow(at: indexPath) as! IllnessCheckbox
            let illness = Illness(id: cell.illnessId, name: cell.illnessLabel.text!)
            if(cell.checkBox.on){ 
                selectedIllnessArr.append(illness)
            } else{
                selectedIllnessArr = selectedIllnessArr.filter{$0.id != cell.illnessId}
            }
            registration.illness = selectedIllnessArr
            if !(registration.illness ?? []).isEmpty {
                nextBtn.isEnabled = true
                nextBtn.alpha = 1
            } else {
                nextBtn.isEnabled = false
                nextBtn.alpha = 0.5
            }
            print(registration.illness)
        }
    }

    @IBAction func nextBtnDidTap(_ sender: Any) {
        // Proceed to next page
        performSegue(withIdentifier: "showRegS6", sender: nil)
    }
}
