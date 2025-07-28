//
//  Account.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 25/7/2025.
//

import SwiftUI
import SwiftData

@Model
class Account {
    var name: String
    var balance: Double // Assume this is initial balance
    var creationDate: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Transaction.sourceAccount)
    var sourceTransactions: [Transaction] = []
    
    @Relationship(deleteRule: .cascade, inverse: \Transaction.destinationAccount)
    var destinationTransactions: [Transaction] = []
    
    init(name: String, balance: Double, date: Date = .now) {
        self.name = name
        self.balance = balance
        self.creationDate = date
    }
    
    var totalTransactions: Double {
        let totalSent = sourceTransactions.reduce(0) { $0 + $1.amount }
        let totalReceived = destinationTransactions.reduce(0) { $0 + $1.amount }
        return totalReceived - totalSent
    }
    
    var netBalance: Double {
        return balance + totalTransactions
    }
}
