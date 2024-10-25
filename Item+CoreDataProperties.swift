//
//  Item+CoreDataProperties.swift
//  ShieldConfigBugExample
//
//  Created by Maximillian Stabe on 25.10.24.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var name: String?

}

extension Item : Identifiable {

}
