//
//  DailyViewController.swift
//  FoodIn
//
//  Created by ryan on 1/2/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import Charts

class MultiDayViewController: UIViewController {
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var barChart: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.delegate = self
        
        let xaxis = barChart.xAxis
        xaxis.drawGridLinesEnabled = true
        xaxis.labelPosition = .bottom
        xaxis.centerAxisLabelsEnabled = true
        xaxis.granularity = 1
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChart.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = false
        
        barChart.rightAxis.enabled = false
        
        // Listen to notification
        NotificationCenter.default.addObserver(self, selector: #selector(setupView), name: Notification.Name(NotificationKey.foodLogData), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Perform action when notification is received
    @objc func setupView() {
        if let foodLog = StatisticsViewController.foodLogs {
//            self.tableView.reloadData()
//            self.tableView.delegate = self
            if  (foodLog.count < 1) {
                //                self.pieChart.isHidden = true
            } else {
                let food = foodLog[0]
//                self.pieChartUpdate(calories: food.calories, carbs: food.carbohydrate, protein: food.protein, fats: food.fat)
                //                self.pieChart.isHidden = false
                
                let groupSpace = 0.08
                let barSpace = 0.03
                let barWidth = 0.2
                
                let totalNutrition = sumNutrition(foodLog)
                let recNutrition = getRecommended()
                
                var dataEntries: [BarChartDataEntry] = []
                var dataEntries1: [BarChartDataEntry] = []
                
                
                var entries: [BarChartDataEntry] = []
                var i = 0
                for (key, value) in totalNutrition {
                    let dataEntry = BarChartDataEntry(x: Double(i) , y: value)
                    dataEntries.append(dataEntry)
                    
                    let dataEntry1 = BarChartDataEntry(x: Double(i) , y: recNutrition[key]!)
                    dataEntries1.append(dataEntry1)
                    i += 1
                }
                //                set1.setColor(UIColor(red: 104/255, green: 241/255, blue: 175/255, alpha: 1))
                
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "Consumed")
                let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "Recommended")
                
                let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1]
                //                chartDataSet.colors = [UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
                chartDataSet.colors = [UIColor(red: 135/255.0, green: 211/255.0, blue: 124/255.0, alpha: 1.0)]
                chartDataSet1.colors = [UIColor(red: 129/255.0, green: 207/255.0, blue: 224/255.0, alpha: 1.0)]
                
                //chartDataSet.colors = ChartColorTemplates.colorful()
                //let chartData = BarChartData(dataSet: chartDataSet)
                
                let chartData = BarChartData(dataSets: dataSets)
                
                // Format text label inside the pie chart
                let pFormatter = NumberFormatter()
                pFormatter.numberStyle = .percent
                pFormatter.maximumFractionDigits = 1
                pFormatter.multiplier = 1
                pFormatter.percentSymbol = "%"
                
                // Make data with dataset//                data.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
                self.barChart.data = chartData
                
                barChart.noDataText = "No data"
                
                chartData.barWidth = barWidth;
                barChart.xAxis.axisMinimum = 0.0
                barChart.xAxis.valueFormatter = self
                barChart.xAxis.labelWidth = CGFloat(barSpace + barWidth * 2)
                let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                print("Groupspace: \(gg)")
                barChart.xAxis.axisMaximum = 0.0 + gg * 9
                
                chartData.groupBars(fromX: 0.0, groupSpace: groupSpace, barSpace: barSpace)
                //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                barChart.notifyDataSetChanged()
                
                barChart.data = chartData
                //
                //                data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
                //                data.setValueFont(Fonts.Regular.of(size: 10))
                self.barChart.notifyDataSetChanged()
                
                //chart animation
                barChart.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
                
            }
        }
    }
    
    func sumNutrition(_ logs: [FoodLog]) -> Dictionary<String, Double> {
        var data = [
            "calories": 0.0,
            "carbohydrate": 0.0,
            "fat": 0.0,
            "protein": 0.0,
            "vitaminA": 0.0,
            "vitaminC": 0.0,
            "sodium": 0.0,
            "potassium": 0.0,
            "calcium": 0.0,
            "iron": 0.0
        ]
        
        for log in logs {
            let logMirror = Mirror(reflecting: log)
            for (key, value) in logMirror.children {
                guard let key = key else { continue }
                if let val = data[key] {
                    guard let value = value as? Double else { continue }
                    data[key] = val + value
                }
            }
        }
        return data
    }
    
    func getRecommended() -> Dictionary<String, Double> {
        let calories = 2000.0
        let data = [
            "calories": calories,
            "carbohydrate": calories * 0.45,
            "fat": calories * 0.25,
            "protein": calories * 0.3,
            "vitaminA": 900.0,
            "vitaminC": 60.0,
            "sodium": 2300,
            "potassium": 4700.0,
            "calcium": 1200.0,
            "iron": 8.0
        ]
        return data
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
}



extension MultiDayViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let logs = StatisticsViewController.foodLogs else { return 0 }
        print("count \(logs.count)")
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let logs = StatisticsViewController.foodLogs else { return cell }
        let log = logs[indexPath.row]
        cell.textLabel?.text = log.name
        return cell
    }
}

extension MultiDayViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var labels = [
            "Cal",
            "Carbo",
            "Fat",
            "Protein",
            "Vita-A",
            "Vita-C",
            "Sodium",
            "Potas",
            "Calcium",
            "Iron"
        ]
        var index = Int(value)
        var label = String(value)
        if index > -1 && Int(value) < labels.count {
            label = labels[index]
        }
        return label
    }
}


