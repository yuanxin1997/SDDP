//
//  MyInfoService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 7/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import CoreData
class MyInfoService {
    
    // Persists
    func persistMyInfo(person: Person) {
        let myInfo = MyInfo(context: PersistenceService.context)
        myInfo.name = person.name
        myInfo.email = person.email
        myInfo.gender = person.gender
        myInfo.dob = person.dob
        myInfo.weight = person.weight
        myInfo.height = person.height
        PersistenceService.saveContext()
    }
    
    // Retrieve
    func getMyInfo() -> [MyInfo] {
        let fetchRequest: NSFetchRequest<MyInfo> = MyInfo.fetchRequest()
        var result = [MyInfo]()
        do {
            let myInfo = try PersistenceService.context.fetch(fetchRequest)
            result = myInfo
        } catch {}
        
        return result
    }
    
    // Clear
    func clearMyInfo() {
        let fetchRequest: NSFetchRequest<MyInfo> = MyInfo.fetchRequest()
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try PersistenceService.context.execute(batchDeleteRequest)
        } catch {}
    }
    
}
