//
//  Student+CoreDataProperties.swift
//  one
//
//  Created by sidney on 2021/10/6.
//
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}

extension Student : Identifiable {

}
