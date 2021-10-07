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
    
    func query(context: NSManagedObjectContext, condition: String) -> NSAsynchronousFetchResult<SchoolClass> {
        let request = NSFetchRequest<SchoolClass>(entityName: entityName)
        request.predicate = NSPredicate(format: condition)
        return try! context.execute(request) as! NSAsynchronousFetchResult<SchoolClass>
    }
    
    func insertData(context: NSManagedObjectContext) -> SchoolClass {
        let entity: SchoolClass = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! SchoolClass
        entity.name = "三年二班\(arc4random() % 20)"
        entity.studentCount = Int16((arc4random() % 100))
        return entity
    }
}
