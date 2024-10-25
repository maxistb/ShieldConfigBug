//
//  Item+CoreDataClass.swift
//  ShieldConfigBugExample
//
//  Created by Maximillian Stabe on 25.10.24.
//
//

import CoreData
import Foundation

@objc(Item)
public class Item: NSManagedObject, Codable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
    return NSFetchRequest<Item>(entityName: "Item")
  }

  @NSManaged public var timestamp: Date?
  @NSManaged public var name: String?

  public class func createItem(
    name: String
  ) -> Item {
    let newItem = Item(context: CoreDataStack.shared.mainContext)
    newItem.name = name
    newItem.timestamp = .now

    try? CoreDataStack.shared.mainContext.save()
    return newItem
  }

  public required convenience init(from decoder: Decoder) throws {
    let context = CoreDataStack.shared.mainContext
    self.init(context: context)

    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.timestamp = try container.decode(Date.self, forKey: .timestamp)
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(name, forKey: .name)
    try container.encode(timestamp, forKey: .timestamp)
  }

  enum CodingKeys: String, CodingKey {
    case name, timestamp
  }
}

extension Item: Identifiable {}
