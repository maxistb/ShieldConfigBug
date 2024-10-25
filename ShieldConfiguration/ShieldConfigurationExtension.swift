//
//  ShieldConfigurationExtension.swift
//  ShieldConfiguration
//
//  Created by Maximillian Stabe on 25.10.24.
//

import CustomCoreData
import ManagedSettings
import ManagedSettingsUI
import OSLog

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
  override func configuration(shielding application: Application) -> ShieldConfiguration {
    guard let items = try? CoreDataStack.shared.mainContext.fetch(Item.fetchRequest()) else {
      return ShieldConfiguration(title: .init(text: "Fallback", color: .blue))
    }

    return ShieldConfiguration(
      title: .init(text: "COUNT \(items.count)", color: .blue)
    )
  }

  // Whats interesting is that it seems like trying to fetch itself crashes the ShieldConfiguration, since only the default Shield is shown, instead of the Fallback Shield.
  // When removing the fetching and always returning the Fallback case, it will show the title Fallback, otherwhise not.
  // Im not quite sure why, since I'm using the same technique in the DeviceActivityMonitor and it works, as you can check in the logs yourself.
  override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
    guard let items = try? CoreDataStack.shared.mainContext.fetch(Item.fetchRequest()) else {
      return ShieldConfiguration(title: .init(text: "Fallback", color: .blue))
    }

    return ShieldConfiguration(
      title: .init(text: "COUNT \(items.count)", color: .blue)
    )
  }

  override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
    return ShieldConfiguration()
  }

  override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
    return ShieldConfiguration()
  }
}
