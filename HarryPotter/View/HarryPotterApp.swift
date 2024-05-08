//
//  HarryPotterApp.swift
//  HarryPotter
//
//  Created by Aman Giri on 2024-04-21.
//

import SwiftUI

@main
struct HarryPotterApp: App {
    @StateObject var store = Store()
    @StateObject var game = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(store)
                .environmentObject(game)
                .task {
                    await store.loadProducts()
                    game.getScores()
                    store.loadBooks()
                }
        }
    }
}
