//
//  ContentView.swift
//  ShieldConfigBugExample
//
//  Created by Maximillian Stabe on 25.10.24.
//

import CoreData
import CustomCoreData
import DeviceActivity
import FamilyControls
import OSLog
import SwiftUI

struct ContentView: View {
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default
  )
  private var items: FetchedResults<Item>

  var body: some View {
    NavigationView {
      List {
        itemList
        monitorButton
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: addItem) {
            Label("Add Item", systemImage: "plus")
          }
        }
      }
      .task {
        try? await AuthorizationCenter.shared.requestAuthorization(for: .individual)
      }
    }
  }

  private var itemList: some View {
    ForEach(items) { item in
      NavigationLink {
        Text("\(item.name!) created at \(item.timestamp!, formatter: itemFormatter)")
      } label: {
        Text(item.timestamp!, formatter: itemFormatter)
      }
    }
    .onDelete(perform: deleteItems)
  }

  private var monitorButton: some View {
    Button("Start Monitoring") {
      DeviceActivityCenter().stopMonitoring([.init("Default Activity")])

      let schedule = DeviceActivitySchedule(
        intervalStart: .init(hour: 0, minute: 0),
        intervalEnd: .init(hour: 23, minute: 59),
        repeats: true
      )

      do {
        try DeviceActivityCenter().startMonitoring(.init("Default Activity"), during: schedule)
      } catch {
        Logger.debug.error("Failed to start monitoring, \(error.localizedDescription)")
      }
    }
  }

  private func addItem() {
    let _ = Item.createItem(name: UUID().uuidString)
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(CoreDataStack.shared.mainContext.delete)

      try? CoreDataStack.shared.mainContext.save()
    }
  }
}

private let itemFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .medium
  return formatter
}()
