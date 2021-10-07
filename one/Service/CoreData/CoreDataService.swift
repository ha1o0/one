//
//  CoreDataService.swift
//  one
//
//  Created by sidney on 2021/10/6.
//

import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    private init() {}
    
    func getContext(modelFileName: String, sqliteFileName: String) -> NSManagedObjectContext? {
        var context: NSManagedObjectContext?
        let modelUrl = Bundle.main.url(forResource: modelFileName, withExtension: "momd")
        if let modelUrl = modelUrl {
            let modelManager = NSManagedObjectModel(contentsOf: modelUrl)
            if let modelManager = modelManager {
                let store = NSPersistentStoreCoordinator(managedObjectModel: modelManager)
                let path = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + sqliteFileName + ".sqlite")
                print(path)
                try! store.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: path, options: nil)
                context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
                context?.persistentStoreCoordinator = store
            }
        }
        return context
    }
}
