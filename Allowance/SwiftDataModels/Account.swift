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
    var balance: Double // Initial balance
    var creationDate: Date

    // Inverse relationships
    @Relationship(deleteRule: .cascade, inverse: \Transaction.sourceAccount)
    var outgoingTransactions: [Transaction] = []

    @Relationship(deleteRule: .cascade, inverse: \Transaction.destinationAccount)
    var incomingTransactions: [Transaction] = []

    init(name: String, balance: Double, date: Date = .now) {
        self.name = name
        self.balance = balance
        self.creationDate = date
    }

    /// Computes net balance: subtract if source, add if destination
    var netBalance: Double {
        let outgoingTotal = outgoingTransactions.reduce(0) { $0 + $1.amount }
        let incomingTotal = incomingTransactions.reduce(0) { $0 + $1.amount }
        return balance + incomingTotal - outgoingTotal
    }

    /// All transactions involving this account
    var allTransactions: [Transaction] {
        (incomingTransactions + outgoingTransactions).sorted(by: { $0.transactionDate > $1.transactionDate })
    }
}
