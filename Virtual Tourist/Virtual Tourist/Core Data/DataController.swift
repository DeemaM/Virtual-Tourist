//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Deema  on 17/07/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import CoreData


class DataController {
    
    static let shared = DataController()
    
    let persistentContainer = NSPersistentContainer(name: "Model")
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func load() {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
        }
    }
    
    func fetchPins(viewContext: NSManagedObjectContext)->[Pin]{
        let fetchRequest : NSFetchRequest<Pin> = Pin.fetchRequest()
        if let fetchedPins = try? viewContext.fetch(fetchRequest){
            return fetchedPins
        }
        
        return []
    }
    
}
