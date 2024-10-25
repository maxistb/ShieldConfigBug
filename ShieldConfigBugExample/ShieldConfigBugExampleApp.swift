//
//  ShieldConfigBugExampleApp.swift
//  ShieldConfigBugExample
//
//  Created by Maximillian Stabe on 25.10.24.
//

import CustomCoreData
import FamilyControls
import SwiftUI

@main
struct ShieldConfigBugExampleApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, CoreDataStack.shared.mainContext)
    }
  }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    Task {
      try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
    }

    return true
  }
}
