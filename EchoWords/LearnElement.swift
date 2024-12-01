//
//  LearnElement.swift
//  EchoWords
//
//  Created by Adrian Emmanuel Faz Mercado on 01/11/24.
//

import Foundation
import SwiftData

enum elementType: Codable {
    case newPhrase
    case howToSay
}

@Model
class LearnElement: ObservableObject {
    var id = UUID()
    var learnType: elementType
    var userEntry: String
    var explanation: String
    var dateAdded: Date
    var isCompleted: Bool = false
    var category: Category? = nil
    
    init(learnType: elementType = .newPhrase, userEntry: String = "", explanation: String = "") {
        self.learnType = learnType
        self.userEntry = userEntry
        self.explanation = explanation
        self.dateAdded = .now
    }
    
}

struct Category: Codable,Hashable {
    var id = UUID()
    var name: String
    var emoji: String
}

var categories: [Category] = [
    Category(name: "Daily Phrases", emoji: "☀️"),
    Category(name: "Transportation", emoji: "🚘"),
    Category(name: "Food", emoji: "🍕"),
    Category(name: "Shopping", emoji: "🛍️"),
    Category(name: "Slang", emoji: "😂")
]
