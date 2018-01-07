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
    
    // Persists
    func persistMyIndicator(indicator: Indicator){
        let myIndicator = MyIndicator(context: PersistenceService.context)
        myIndicator.illnessId = Int16(indicator.illnessId)
        myIndicator.name = indicator.name
        myIndicator.maxValue = indicator.maxValue
        myIndicator.minValue = indicator.minValue
        PersistenceService.saveContext()
    }
    
    // Retrieve
    func getMyIndicator() -> [MyIndicator] {
        let fetchRequest: NSFetchRequest<MyIndicator> = MyIndicator.fetchRequest()
        var result = [MyIndicator]()
        do {
            let myIndicator = try PersistenceService.context.fetch(fetchRequest)
            result = myIndicator
        } catch {}
        
        return result
    }
    
    // Clear
    func clearMyIndicator() {
        let fetchRequest: NSFetchRequest<MyIndicator> = MyIndicator.fetchRequest()
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try PersistenceService.context.execute(batchDeleteRequest)
        } catch {}
    }
    
}
