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

class NutrientViewController: UIViewController, IndicatorInfoProvider {

    @IBOutlet weak var pieChart: PieChartView!
    
    var fService = FoodService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fService.getFoodDetails(foodName: FoodDetailsController.parentFoodName!, completion: { (result: Food?) in
            DispatchQueue.main.async {
                if let result = result {
                    // Refresh UI
                    self.pieChartUpdate(calories: result.calories, carbs: result.carbohydrate, protein: result.protein, fats: result.fat)
                }
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Nutrient")
    }
    
    func pieChartUpdate (calories: Double, carbs: Double, protein: Double, fats: Double) {
        // 1g carbohydrate = 4 calories
        // 1g protein = 4 calories
        // 1g fat = 9 calories
        let caloriesInCarbs = carbs * 4
        let caloriesInProtein = protein * 4
        let caloriesInFats = fats * 9
        
        // Basic set up of plan chart
        let entry1 = PieChartDataEntry(value: caloriesInCarbs, label: "Carbs")
        let entry2 = PieChartDataEntry(value: caloriesInProtein, label: "Protein")
        let entry3 = PieChartDataEntry(value: caloriesInFats, label: "Fats")
        
        let dataSet = PieChartDataSet(values: [entry1, entry2, entry3], label: "")
        dataSet.drawIconsEnabled = false
        dataSet.sliceSpace = 3
        dataSet.valueColors = [.white]
        dataSet.colors =
            [UIColor(red: 135/255.0, green: 211/255.0, blue: 124/255.0, alpha: 1.0)]
            + [UIColor(red: 129/255.0, green: 207/255.0, blue: 224/255.0, alpha: 1.0)]
            + [UIColor(red: 233/255.0, green: 212/255.0, blue: 96/255.0, alpha: 1.0)]
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = "%"
        
        let data = PieChartData(dataSet: dataSet)
        pieChart.data = data
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(Fonts.Regular.of(size: 10))
        
        // Pie Chart legend
        let l = pieChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.xEntrySpace = 45
        l.yEntrySpace = 0
        l.yOffset = 0
        l.font = Fonts.Regular.of(size: 12)
        
        pieChart.animate(xAxisDuration: 1.5, easingOption: .easeOutBack)
        pieChart.usePercentValuesEnabled = true
        pieChart.drawEntryLabelsEnabled = false
        pieChart.holeColor = UIColor.clear
        pieChart.legend.textColor = Colors.lightgrey
        pieChart.chartDescription?.enabled = false
        pieChart.drawCenterTextEnabled = true
        let attributedString = NSMutableAttributedString(string: "\(Int(calories))\nCalories")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center // center the text

        attributedString.addAttributes([NSAttributedStringKey.font: Fonts.Regular.of(size: 16), NSAttributedStringKey.foregroundColor : Colors.lightgrey, NSAttributedStringKey.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedString.length))
        pieChart.centerAttributedText = attributedString;
        pieChart.holeRadiusPercent = 0.65
        pieChart.transparentCircleRadiusPercent = 0
        
        // Refresh chart with new data
        pieChart.notifyDataSetChanged()
    }

}
