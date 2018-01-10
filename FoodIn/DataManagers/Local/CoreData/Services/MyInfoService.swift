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
    
    // The Managed Object Context is used to create, read, update, and delete records.

    // Persists
    func persistMyInfo(person: Person) {
        
        // Get context and pass in the values
        let myInfo = MyInfo(context: PersistenceService.context)
        myInfo.name = person.name
        myInfo.email = person.email
        myInfo.gender = person.gender
        myInfo.dob = person.dob
        myInfo.weight = person.weight
        myInfo.height = person.height
        
        // Save context
        PersistenceService.saveContext()
    }
    
    // Retrieve
    func getMyInfo() -> [MyInfo] {
        
        // Create fetch request
        let fetchRequest: NSFetchRequest<MyInfo> = MyInfo.fetchRequest()
        var result = [MyInfo]()
        
        do {
            // Get context and execute your request
            let myInfo = try PersistenceService.context.fetch(fetchRequest)
            result = myInfo
        } catch {}
        
        return result
    }
    
    // Clear
    func clearMyInfo() {
        
        // Create fetch request
        let fetchRequest: NSFetchRequest<MyInfo> = MyInfo.fetchRequest()
        
        // Pass in the fetch request result
        // To create batch delete request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            // Get context and execute your request
            try PersistenceService.context.execute(batchDeleteRequest)
        } catch {}
    }
    
}
