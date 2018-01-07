//
//  MyIndicator+CoreDataProperties.swift
//  FoodIn
//
//  Created by Yuanxin Li on 7/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//
//

import Foundation
import CoreData


extension MyIndicator {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyIndicator> {
        return NSFetchRequest<MyIndicator>(entityName: "MyIndicator")
    }

    @NSManaged public var illnessId: Int16
    @NSManaged public var maxValue: Double
    @NSManaged public var minValue: Double
    @NSManaged public var name: String?

}
