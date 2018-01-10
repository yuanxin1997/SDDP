//
//  MyIllness+CoreDataProperties.swift
//  FoodIn
//
//  Created by Yuanxin Li on 7/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//
//

import Foundation
import CoreData

extension MyIllness {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyIllness> {
        return NSFetchRequest<MyIllness>(entityName: "MyIllness")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}
