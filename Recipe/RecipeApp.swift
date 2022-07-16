//
//  RecipeApp.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import SwiftUI

@main
struct RecipeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CategoryView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
