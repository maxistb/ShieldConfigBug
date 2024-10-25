//
// Copyright © 2024 Maximillian Joel Stabe. All rights reserved.
//

import CoreData
import Foundation

/*
 This is the CoreDataManager used by the app. It saves changes to disk.

 Managers can do operations via the:
 - `mainContext` with interacts on the main UI thread, or
 - `backgroundContext` with has a separate queue for background processing
 */
public class CoreDataStack {
  public static let shared = CoreDataStack()

  public let persistentContainer: NSPersistentCloudKitContainer
  public let backgroundContext: NSManagedObjectContext
  public let mainContext: NSManagedObjectContext

  private init() {
    let modelURL = Bundle.main.url(forResource: "Screenless", withExtension: ".momd")!
    let model = NSManagedObjectModel(contentsOf: modelURL)!
    let url = URL.storeURL(for: "group.com.maximillian-stabe.screenless", databaseName: "Screenless")
    let storeDescription = NSPersistentStoreDescription(url: url)
    storeDescription.isReadOnly = false
    storeDescription.type = NSSQLiteStoreType

    persistentContainer = NSPersistentCloudKitContainer(name: "Screenless", managedObjectModel: model)
    persistentContainer.persistentStoreDescriptions = [storeDescription]

    persistentContainer.loadPersistentStores { _, error in
      guard error == nil else {
        fatalError("was unable to load store \(error?.localizedDescription ?? "")")
      }
    }

    mainContext = persistentContainer.viewContext
    mainContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    backgroundContext.parent = mainContext
  }

  public func destroyPersistentStore() {
    persistentContainer.loadPersistentStores { description, _ in
      if let url = description.url {
        let coordinator = self.persistentContainer.persistentStoreCoordinator
        try? coordinator.destroyPersistentStore(at: url, type: .sqlite)
        _ = try? coordinator.addPersistentStore(type: .sqlite, at: url)
      }
    }
  }

  @objc func storeRemoteChange(_ notification: Notification) {
    mainContext.perform {
      self.mainContext.mergeChanges(fromContextDidSave: notification)
    }
  }
}

public extension URL {
  static func storeURL(for appGroup: String, databaseName: String) -> URL {
    guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
      fatalError("FAIL")
    }

    return fileContainer.appendingPathComponent("\(databaseName).sqlite")
  }
}
