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
    
    // Persists
    func persistMyIllness(illness: Illness){
        let myIllness = MyIllness(context: PersistenceService.context)
        myIllness.id = Int16(illness.id)
        myIllness.name = illness.name
        PersistenceService.saveContext()
    }
    
    // Retrieve
    func getMyIllness() -> [MyIllness] {
        let fetchRequest: NSFetchRequest<MyIllness> = MyIllness.fetchRequest()
        var result = [MyIllness]()
        do {
            let myIllness = try PersistenceService.context.fetch(fetchRequest)
            result = myIllness
        } catch {}
        
        return result
    }
    
    // Clear
    func clearMyIllness() {
        let fetchRequest: NSFetchRequest<MyIllness> = MyIllness.fetchRequest()
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try PersistenceService.context.execute(batchDeleteRequest)
        } catch {}
    }
    
}
