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
    
    @Relationship(deleteRule: .cascade, inverse: \Transaction.account)
    var transactions: [Transaction] = []
    
    init(name: String, balance: Double, date: Date = .now) {
        self.name = name
        self.balance = balance
        self.creationDate = date
    }

    var netBalance: Double {
        return balance
    }
}
