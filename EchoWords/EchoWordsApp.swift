//
//  EchoWordsApp.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 27/10/24.
//

import SwiftUI
import SwiftData

@main
struct EchoWordsApp: App {
    var body: some Scene {
        WindowGroup {
            
            TabView {
                Tab("My Pendings",systemImage: "folder.fill.badge.plus") {
                    ContentView()
                }
                
                Tab("My Collection", systemImage: "books.vertical.fill") {
                    CollectionView()
                }
                
            }
        }.modelContainer(for: LearnElement.self)
    }
}
