//
//  NutrientViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 27/12/17.
//  Copyright © 2017 Yuanxin Li. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Charts

class LabelNutrientViewController: UIViewController, IndicatorInfoProvider {
    
    @IBOutlet weak var pieChart: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        setupPieChart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Perform action when notification is received
    @objc func setupPieChart() {
        if let data = LabelResults.sharedInstance.data {
            self.pieChartUpdate(calories: data["calories"]!, carbs: data["carbohydrate"]!, protein: data["protein"]!, fats: data["fat"]!)
        }
    }
    
    func pieChartUpdate (calories: Double, carbs: Double, protein: Double, fats: Double) {
        // 1g carbohydrate = 4 calories
        // 1g protein = 4 calories
        // 1g fat = 9 calories
        let caloriesInCarbs = carbs * 4
        let caloriesInProtein = protein * 4
        let caloriesInFats = fats * 9
        
        // Specify all entry
        let entry1 = PieChartDataEntry(value: caloriesInCarbs, label: "Carbs")
        let entry2 = PieChartDataEntry(value: caloriesInProtein, label: "Protein")
        let entry3 = PieChartDataEntry(value: caloriesInFats, label: "Fats")
        
        // Put all entry into dataset
        let dataSet = PieChartDataSet(values: [entry1, entry2, entry3], label: "")
        
        // Customize pie chart
        dataSet.drawIconsEnabled = false
        dataSet.sliceSpace = 3
        dataSet.valueColors = [.white]
        dataSet.colors =
            [UIColor(red: 135/255.0, green: 211/255.0, blue: 124/255.0, alpha: 1.0)]
            + [UIColor(red: 129/255.0, green: 207/255.0, blue: 224/255.0, alpha: 1.0)]
            + [UIColor(red: 233/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0)]
        
        // Format text label inside the pie chart
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        
        // Make data with dataset
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(Fonts.Regular.of(size: 10))
        
        // Customize pie chart legend
        let l = pieChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.xEntrySpace = 45
        l.yEntrySpace = 0
        l.yOffset = 0
        l.font = Fonts.Regular.of(size: 12)
        
        // Customize pie chart
        pieChart.animate(xAxisDuration: 1.5, easingOption: .easeOutBack)
        pieChart.usePercentValuesEnabled = true
        pieChart.drawEntryLabelsEnabled = false
        pieChart.holeColor = UIColor.clear
        pieChart.legend.textColor = Colors.lightgrey
        pieChart.chartDescription?.enabled = false
        pieChart.drawCenterTextEnabled = true
        let attributedString = NSMutableAttributedString(string: "\(Int(calories))\nCalories")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        attributedString.addAttributes([NSAttributedStringKey.font: Fonts.Regular.of(size: 16), NSAttributedStringKey.foregroundColor : Colors.lightgrey, NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
        pieChart.centerAttributedText = attributedString;
        pieChart.holeRadiusPercent = 0.65
        pieChart.transparentCircleRadiusPercent = 0
        
        // Refresh pie chart with new data
        pieChart.notifyDataSetChanged()
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Nutrient")
    }
    
}


