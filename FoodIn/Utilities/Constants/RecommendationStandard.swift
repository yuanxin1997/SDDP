//
//  RecommendationStandard.swift
//  FoodIn
//
//  Created by Yuanxin Li on 23/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit

// Food and Nutrition Board, Institute of Medicine, National Academies
// Dietary Reference Intakes (DRIs): Recommended Dietary Allowances and Adequate Intakes,
// Mineral: https://www.ncbi.nlm.nih.gov/books/NBK56068/table/summarytables.t2/?report=objectonly
// Vitamin: https://www.ncbi.nlm.nih.gov/books/NBK56068/table/summarytables.t3/?report=objectonly
// Nutrient: https://www.ncbi.nlm.nih.gov/books/NBK56068/table/summarytables.t4/?report=objectonly

class RecommendationStandard {
    var carbohydrate: Double?   // unit: g
    var protein: Double?        // unit: g
    var vitaminA: Double?       // unit: mcg
    var vitaminC: Double?       // unit: mg
    var sodium: Double?         // unit: mg
    var potassium: Double?      // unit: mg
    var calcium: Double?        // unit: mg
    var iron: Double?           // unit: mg
    
    // ===== Gender =====
    // male
    // female
    
    // ===== Age =====
    // 4-8
    // 9-13
    // 14-18
    // 19-30
    // 31-50
    // 51-70
    // >70
    
    enum selectedRow {
        case M1
        case M2
        case M3
        case M4
        case M5
        case M6
        case F1
        case F2
        case F3
        case F4
        case F5
        case F6
        case C1
    }

    init(info: MyInfo) {
        switch (getRowId(gender: info.gender!, age: calcAge(birthday: info.dob!))) {
        case .M1:
            self.carbohydrate = 130
            self.protein = 34
            self.vitaminA = 600
            self.vitaminC = 45
            self.sodium = 1500
            self.potassium = 4500
            self.calcium = 1300
            self.iron = 1500
        case .M2:
            self.carbohydrate = 130
            self.protein = 52
            self.vitaminA = 900
            self.vitaminC = 75
            self.sodium = 1500
            self.potassium = 4700
            self.calcium = 1300
            self.iron = 11
        case .M3:
            self.carbohydrate = 130
            self.protein = 56
            self.vitaminA = 900
            self.vitaminC = 90
            self.sodium = 1500
            self.potassium = 4700
            self.calcium = 1000
            self.iron = 8
        case .M4:
            self.carbohydrate = 130
            self.protein = 56
            self.vitaminA = 900
            self.vitaminC = 90
            self.sodium = 1500
            self.potassium = 4700
            self.calcium = 1000
            self.iron = 8
        case .M5:
            self.carbohydrate = 130
            self.protein = 56
            self.vitaminA = 900
            self.vitaminC = 90
            self.sodium = 1300
            self.potassium = 4700
            self.calcium = 1000
            self.iron = 8
        case .M6:
            self.carbohydrate = 130
            self.protein = 56
            self.vitaminA = 900
            self.vitaminC = 90
            self.sodium = 1200
            self.potassium = 4700
            self.calcium = 1200
            self.iron = 8
        case .F1:
            self.carbohydrate = 130
            self.protein = 34
            self.vitaminA = 600
            self.vitaminC = 45
            self.sodium = 1500
            self.potassium = 4500
            self.calcium = 1300
            self.iron = 8
        case .F2:
            self.carbohydrate = 130
            self.protein = 46
            self.vitaminA = 700
            self.vitaminC = 65
            self.sodium = 1500
            self.potassium = 4700
            self.calcium = 1300
            self.iron = 15
        case .F3:
            self.carbohydrate = 130
            self.protein = 46
            self.vitaminA = 700
            self.vitaminC = 75
            self.sodium = 1500
            self.potassium = 4700
            self.calcium = 1000
            self.iron = 18
        case .F4:
            self.carbohydrate = 130
            self.protein = 46
            self.vitaminA = 700
            self.vitaminC = 75
            self.sodium = 1500
            self.potassium = 4700
            self.calcium = 1000
            self.iron = 18
        case .F5:
            self.carbohydrate = 130
            self.protein = 46
            self.vitaminA = 700
            self.vitaminC = 75
            self.sodium = 1300
            self.potassium = 4700
            self.calcium = 1200
            self.iron = 8
        case .F6:
            self.carbohydrate = 130
            self.protein = 46
            self.vitaminA = 700
            self.vitaminC = 75
            self.sodium = 1200
            self.potassium = 4700
            self.calcium = 1200
            self.iron = 8
        case .C1:
            self.carbohydrate = 130
            self.protein = 19
            self.vitaminA = 400
            self.vitaminC = 25
            self.sodium = 1200
            self.potassium = 3800
            self.calcium = 1000
            self.iron = 10
        }
    }
    
    func getRowId(gender: String, age: Int) -> selectedRow {
        if gender == "male" && (age >= 9 && age <= 13) {
            return .M1
        } else if gender == "male" && (age >= 14 && age <= 18) {
            return .M2
        } else if gender == "male" && (age >= 19 && age <= 30) {
            return .M3
        } else if gender == "male" && (age >= 31 && age <= 50) {
            return .M4
        } else if gender == "male" && (age >= 51 && age <= 70) {
            return .M5
        } else if gender == "male" && (age > 70) {
            return .M6
        } else if gender == "female" && (age >= 9 && age <= 13) {
            return .F1
        } else if gender == "female" && (age >= 14 && age <= 18) {
            return .F2
        } else if gender == "female" && (age >= 19 && age <= 30) {
            return .F3
        } else if gender == "female" && (age >= 31 && age <= 50) {
            return .F4
        } else if gender == "female" && (age >= 51 && age <= 70) {
            return .F5
        } else if gender == "female" && (age > 70) {
            return .F6
        }
        return .C1
    }
    
    func with(indicator: [MyIndicator]) -> RecommendationStandard {
        for i in indicator {
            switch i.name! {
                case "carbohydrate":    self.carbohydrate = i.maxValue
                case "protein":         self.protein = i.maxValue
                case "vitaminA":        self.vitaminA = i.maxValue
                case "vitaminC":        self.vitaminC = i.maxValue
                case "sodium":          self.sodium = i.maxValue
                case "potassium":       self.potassium = i.maxValue
                case "calcium":         self.calcium = i.maxValue
                case "iron":            self.iron = i.maxValue
                default:                print("None")
            }
        }
        return self
    }
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd/MM/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }

}




