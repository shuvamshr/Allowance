//
//  ContentView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 25/7/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            TransactionView()
                .tabItem {
                    Label("Transaction", systemImage: "banknote.fill")
                }
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "wallet.bifold.fill")
                }
        }
    }
}


#Preview("Transaction Preview") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: Account.self, Transaction.self,
        configurations: config
    )
    
    let context = container.mainContext
    
    // Create sample accounts
    let commBank = Account(name: "CommBank", balance: 24.0)
    let westpac = Account(name: "Westpac", balance: 75.5)
    
    // Insert accounts into context
    context.insert(commBank)
    context.insert(westpac)
    
    // Create sample transactions
    let t1 = Transaction(
        title: "Groceries",
        notes: "Bought fruits and veggies",
        amount: -30.0,
        type: .Expense,
        date: .now,
        account: commBank
    )
    
    let t2 = Transaction(
        title: "Salary",
        notes: "Monthly pay",
        amount: 2000.0,
        type: .Income,
        date: .now,
        account: westpac
    )
    
    // Insert transactions into context
    context.insert(t1)
    context.insert(t2)

    return NavigationStack {
        ContentView()
            .modelContainer(container)
    }
}
