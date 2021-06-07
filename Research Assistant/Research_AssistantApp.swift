//
//  Research_AssistantApp.swift
//  Research Assistant
//
//  Created by Zachary Lazzara on 2021-06-07.
//

import SwiftUI

@main
struct Research_AssistantApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
