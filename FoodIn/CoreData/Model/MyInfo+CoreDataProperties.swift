//
//  MyInfo+CoreDataProperties.swift
//  FoodIn
//
//  Created by Yuanxin Li on 7/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//
//

import Foundation
import CoreData


extension MyInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyInfo> {
        return NSFetchRequest<MyInfo>(entityName: "MyInfo")
    }

    @NSManaged public var dob: String?
    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var height: Double
    @NSManaged public var name: String?
    @NSManaged public var weight: Double

}
