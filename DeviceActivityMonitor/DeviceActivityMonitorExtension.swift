//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitor
//
//  Created by Maximillian Stabe on 25.10.24.
//

import CustomCoreData
import DeviceActivity
import ManagedSettings
import OSLog

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
  override func intervalDidStart(for activity: DeviceActivityName) {
    super.intervalDidStart(for: activity)
        
    // simply just block all apps
    let store = ManagedSettingsStore(named: ManagedSettingsStore.Name("Default Store"))
    store.shield.applicationCategories = .all(except: [])
    store.shield.webDomainCategories = .all(except: [])
    
    let items = try? CoreDataStack.shared.mainContext.fetch(Item.fetchRequest())
    Logger.debug.info("CoreData Entity Count: \(items?.count ?? -1, privacy: .public)")
  }
    
  override func intervalDidEnd(for activity: DeviceActivityName) {
    super.intervalDidEnd(for: activity)
        
    // Handle the end of the interval.
  }
    
  override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
    super.eventDidReachThreshold(event, activity: activity)
        
    // Handle the event reaching its threshold.
  }
    
  override func intervalWillStartWarning(for activity: DeviceActivityName) {
    super.intervalWillStartWarning(for: activity)
        
    // Handle the warning before the interval starts.
  }
    
  override func intervalWillEndWarning(for activity: DeviceActivityName) {
    super.intervalWillEndWarning(for: activity)
        
    // Handle the warning before the interval ends.
  }
    
  override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
    super.eventWillReachThresholdWarning(event, activity: activity)
        
    // Handle the warning before the event reaches its threshold.
  }
}
