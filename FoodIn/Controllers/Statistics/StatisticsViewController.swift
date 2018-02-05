//
//  StatisticsViewController.swift
//  FoodIn
//
//  Created by ryan on 12/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import FSCalendar
import Charts
import KeychainSwift

class StatisticsViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var container: UIView!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var radarChart: RadarChartView!
    
    static var foodLogs: [FoodLog]?
    var pService = PersonService()
    var selectedDates: [Date] = []
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    private lazy var DailyViewController: UIViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "DailyViewController") as! UIViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var WeeklyViewController: UIViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "WeeklyViewController") as! UIViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private func add(asChildViewController viewController: UIViewController) {
        // Add Child View Controller
        addChildViewController(viewController)
        
        // Add Child View as Subview
        container.addSubview(viewController.view)
        
        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Food Log"
        
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.showNavBar, .whiteNavTitle, .pinkNavTintBar])
        // Handle swiping to expand calendar
        self.view.addGestureRecognizer(self.scopeGesture)
        //self.radarChart.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        
        // Setup calendar styling
        setupCalendar()
        
//        // Select today
//        self.calendar.select(Date())
//        calendarUpdate()
        // Setup radar chart
//        setupRadarChart()
    }
    
    func setupRadarChart() {
        radarChart.chartDescription?.enabled = false
        radarChart.webLineWidth = 1
        radarChart.innerWebLineWidth = 1
        radarChart.webColor = .lightGray
        radarChart.innerWebColor = .lightGray
        radarChart.webAlpha = 0.7
        
        let xAxis = radarChart.xAxis
        xAxis.labelFont = Fonts.Regular.of(size: 12)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = Colors.lightgrey
        
        let yAxis = radarChart.yAxis
        yAxis.drawLabelsEnabled = false
        
        let l = radarChart.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.font = Fonts.Regular.of(size: 12)
        
        radarChart.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeOutBack)
        radarChart.legend.textColor = Colors.lightgrey
        
        // Refresh chart with new data
        radarChart.notifyDataSetChanged()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.defaultNavTintBar])
    }
    
    func setupCalendar() {
        self.calendar.allowsMultipleSelection = true
        
        self.calendar.backgroundColor = Colors.pink
        self.calendar.appearance.headerTitleColor = Colors.ghostwhite
        self.calendar.appearance.titleDefaultColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.8)
        self.calendar.appearance.weekdayTextColor = Colors.ghostwhite
        self.calendar.appearance.titleSelectionColor = self.calendar.backgroundColor
        
        self.calendar.appearance.selectionColor = Colors.ghostwhite
        self.calendar.appearance.eventDefaultColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        self.calendar.appearance.eventSelectionColor = self.calendar.backgroundColor
        self.calendar.appearance.todaySelectionColor = self.calendar.appearance.selectionColor
        self.calendar.appearance.todayColor = UIColor.clear
        self.calendar.appearance.titleTodayColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        self.calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        self.calendar.register(FoodLogDate.self, forCellReuseIdentifier: "cell")
        
        self.calendar.dataSource = self
        self.calendar.delegate = self
    }
    func fetchData(from: UInt64, to: UInt64) {
        let tService = TranslateService()
        tService.translate("probando el servicio de traducción de google",  completion: { (result: String) in
            DispatchQueue.main.async {
                print("Translation: \(result)")
            }
        })
        print("fetching data from \(from) to \(to)")
        guard let id = Int(KeychainSwift().get("id")!) else { return }
        pService.getFoodLog(personId: id, from: from, to: to, completion: { (result: [FoodLog]?) in
            DispatchQueue.main.async {
                if let result = result {
                    StatisticsViewController.foodLogs = result
                    NotificationCenter.default.post(name: Notification.Name(NotificationKey.foodLogData), object: nil)
                    self.updateGraphs()
//                    self.updateRadarChart()
                }
            }
        })
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

    func convertToDatasetFrom(dict: Dictionary<String, Double>, label: String? = nil, color: UIColor = Colors.pink) -> RadarChartDataSet {
        var entries: [RadarChartDataEntry] = []
        for (nutrient, value) in dict {
            entries.append(RadarChartDataEntry(value: value, data: nutrient as AnyObject))
        }
        let dataSet = RadarChartDataSet(values: entries, label: "Nutrition")
        dataSet.drawIconsEnabled = false
        dataSet.valueColors = [color]
        dataSet.colors = [color]
        dataSet.drawFilledEnabled = true
        dataSet.fillColor = color
        if let label = label { dataSet.label = label }
        return dataSet
    }
    
    func updateRadarChart() {
        guard let foodLogs = StatisticsViewController.foodLogs else { return }
        let logs = sumNutrition(foodLogs)
        let rec = getRecommended()
        let data = RadarChartData(dataSets: [
            convertToDatasetFrom(dict: logs, label: "Daily"),
            convertToDatasetFrom(dict: rec, label: "Recommended", color: UIColor.green)
        ])
        radarChart.data = data
        print("data \(data)")
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.blackStatusBar, .greyNavTitle])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = true
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
    }
}

// Calendar

extension StatisticsViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        var number = 0
        guard let id = Int(KeychainSwift().get("id")!) else { return number }
        guard let endDay = date.endOfDay else { return number }
        let to = UInt64(floor(endDay.timeIntervalSince1970))
        let from = UInt64(floor(date.startOfDay.timeIntervalSince1970))
        pService.getFoodLog(personId: id, from: from, to: to) { (result: [FoodLog]?) in
            if let result = result {
                number = result.count
            }
        }
        return number;
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        calendarUpdate()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendarUpdate()
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    private func calendarUpdate() {
        self.calendar.visibleCells().forEach { (cell) in
            guard let date = calendar.date(for: cell) else { return }
            let position = calendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date, at: position)
        }
        
        self.selectedDates = calendar.selectedDates
        
        if (self.selectedDates.count == 0) {
//            fetchData(from: 0, to: 0)
            StatisticsViewController.foodLogs = []
        } else {
            // Sot by ascending
            let selectedDates = self.selectedDates.sorted(by: { $0 < $1})
            guard let first = selectedDates.first else { return }
            guard let last = selectedDates.last else { return }
            guard let endDay = last.endOfDay else { return }
            let to = UInt64(floor(endDay.timeIntervalSince1970))
            let from = UInt64(floor(first.startOfDay.timeIntervalSince1970))
            fetchData(from: from, to: to)
        }
    }
    
    private func updateGraphs() {
        if(self.selectedDates.count <= 1) {
            remove(asChildViewController: WeeklyViewController)
            add(asChildViewController: DailyViewController)
        } else {
            remove(asChildViewController: DailyViewController)
            add(asChildViewController: WeeklyViewController)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let diyCell = (cell as! FoodLogDate)
        // Custom today circle
        //diyCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            
            if calendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if calendar.selectedDates.contains(date) {
                    if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    }
                    else if calendar.selectedDates.contains(previousDate) && calendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    }
                    else if calendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    }
                    else {
                        selectionType = .single
                    }
                }
            }
            else {
                selectionType = .none
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
            
        } else {
            //diyCell.circleImageView.isHidden = true
            diyCell.selectionLayer.isHidden = true
        }
    }
}

extension StatisticsViewController: IAxisValueFormatter {
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
        if Int(value) < labels.count {
            label = labels[index]
        }
        return label
    }
}
