//
//  ClipVaultApp.swift
//  ClipVault
//
//  Created by Daniil Mukashev on 2025-11-20.
//

import SwiftUI
import CoreData

@main
struct ClipVaultApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
