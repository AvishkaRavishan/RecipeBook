//
//  RecipeBookApp.swift
//  RecipeBook
//
//  Created by AVISHKA RAVISHAN on 2023-06-16.
//

import SwiftUI

@main
struct RecipeBookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
