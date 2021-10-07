//
//  SchoolClass+CoreDataProperties.swift
//  one
//
//  Created by sidney on 2021/10/6.
//
//

import Foundation
import CoreData


extension SchoolClass {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SchoolClass> {
        return NSFetchRequest<SchoolClass>(entityName: "SchoolClass")
    }

    @NSManaged public var studentCount: Int16
    @NSManaged public var name: String?
    @NSManaged public var monitor: Student?

}

extension SchoolClass : Identifiable {

}
