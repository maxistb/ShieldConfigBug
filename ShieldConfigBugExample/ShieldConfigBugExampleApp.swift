//
//  ShieldConfigBugExampleApp.swift
//  ShieldConfigBugExample
//
//  Created by Maximillian Stabe on 25.10.24.
//

import SwiftUI

@main
struct ShieldConfigBugExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
