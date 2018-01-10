//
//  MyIllnessService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 7/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import CoreData

class MyIllnessService {
    
    // The Managed Object Context is used to create, read, update, and delete records.
    
    // Persists
    func persistMyIllness(illness: Illness){
        
        // Get context and pass in the values
        let myIllness = MyIllness(context: PersistenceService.context)
        myIllness.id = Int16(illness.id)
        myIllness.name = illness.name
        
        // Save context
        PersistenceService.saveContext()
    }
    
    // Retrieve
    func getMyIllness() -> [MyIllness] {
        
        // Create fetch request
        let fetchRequest: NSFetchRequest<MyIllness> = MyIllness.fetchRequest()
        var result = [MyIllness]()
        
        do {
            // Get context and execute your request
            let myIllness = try PersistenceService.context.fetch(fetchRequest)
            result = myIllness
        } catch {}
        
        return result
    }
    
    // Clear
    func clearMyIllness() {
        
        // Create fetch request
        let fetchRequest: NSFetchRequest<MyIllness> = MyIllness.fetchRequest()
        
        // Pass in the fetch request result
        // To create batch delete request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            // Get context and execute your request
            try PersistenceService.context.execute(batchDeleteRequest)
        } catch {}
    }
    
}
