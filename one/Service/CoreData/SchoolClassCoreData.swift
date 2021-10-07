//
//  SchoolClassCoreData.swift
//  one
//
//  Created by sidney on 2021/10/6.
//

import Foundation
import CoreData

class SchoolClassCoreData {
    
    static let shared = SchoolClassCoreData()
    let entityName = "SchoolClass"
    
    private init() {}
    
    func query(context: NSManagedObjectContext, condition: String, success: @escaping ([SchoolClass]) -> Void) {
        let request = NSFetchRequest<SchoolClass>(entityName: entityName)
        request.predicate = NSPredicate(format: condition)
        let asyncFetch = NSAsynchronousFetchRequest(fetchRequest: request) { (result: NSAsynchronousFetchResult<SchoolClass>) in
            success(result.finalResult ?? [])
        }
        try! context.execute(asyncFetch)
    }
    
    func insertData(context: NSManagedObjectContext) -> SchoolClass {
        let entity: SchoolClass = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! SchoolClass
        entity.name = "三年二班\(arc4random() % 20)"
        entity.studentCount = Int16((arc4random() % 100))
        return entity
    }
}
