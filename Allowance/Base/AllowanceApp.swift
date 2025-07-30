//
//  AllowanceApp.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 25/7/2025.
//

import SwiftUI
import SwiftData

@main
struct AllowanceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Account.self, Transaction.self, Category.self])
    }
}
