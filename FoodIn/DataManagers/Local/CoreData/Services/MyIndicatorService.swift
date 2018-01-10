//
//  MyIndicatorService.swift
//  FoodIn
//
//  Created by Yuanxin Li on 7/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import Foundation
import CoreData

class MyIndicatorService {
    
    // The Managed Object Context is used to create, read, update, and delete records.
    
    // Persists
    func persistMyIndicator(indicator: Indicator){
        
        // Get context and pass in the values
        let myIndicator = MyIndicator(context: PersistenceService.context)
        myIndicator.illnessId = Int16(indicator.illnessId)
        myIndicator.name = indicator.name
        myIndicator.maxValue = indicator.maxValue
        myIndicator.minValue = indicator.minValue
        
        // Save context
        PersistenceService.saveContext()
    }
    
    // Retrieve
    func getMyIndicator() -> [MyIndicator] {
        
        // Create fetch request
        let fetchRequest: NSFetchRequest<MyIndicator> = MyIndicator.fetchRequest()
        var result = [MyIndicator]()
        
        do {
            // Get context and execute your request
            let myIndicator = try PersistenceService.context.fetch(fetchRequest)
            result = myIndicator
        } catch {}
        
        return result
    }
    
    // Clear
    func clearMyIndicator() {
        
        // Create fetch request
        let fetchRequest: NSFetchRequest<MyIndicator> = MyIndicator.fetchRequest()
        
        // Pass in the fetch request result
        // To create batch delete request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        
        do {
            // Get context and execute your request
            try PersistenceService.context.execute(batchDeleteRequest)
        } catch {}
    }
    
}
