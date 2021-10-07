//
//  StudentCoreData.swift
//  one
//
//  Created by sidney on 2021/10/6.
//

import Foundation
import CoreData

class StudentCoreData {
    static let shared = StudentCoreData()
    let entityName = "Student"
    
    private init() {}
    
    func insertData(context: NSManagedObjectContext) -> Student {
        let entity: Student = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Student
        entity.name = "李四\(arc4random() % 20)"
        entity.age = Int16((arc4random() % 100))
        return entity
    }
    
}
