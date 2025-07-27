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
    var transactions: [Transaction] = []
    
    init(name: String, balance: Double, date: Date = .now) {
        self.name = name
        self.balance = balance
        self.creationDate = date
    }
    
    var totalTransactions: Double {
        transactions.reduce(0.0) { result, transaction in
            switch transaction.transactionType {
            case .Income:
                return result + transaction.amount
            case .Expense:
                return result - transaction.amount
            case .Transfer:
                return result // Adjust logic if needed
            }
        }
    }
    
    var netBalance: Double {
        return balance + totalTransactions
    }
}
