//
//  Transaction.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 27/7/2025.
//

import Foundation
import SwiftData

@Model
class Transaction {
    var title: String
    var notes: String
    var amount: Double
    var transactionType: TransactionType
    var transactionDate: Date
    var account: Account
    
    init(title: String, notes: String, amount: Double, transactionType: TransactionType, transactionDate: Date, account: Account) {
        self.title = title
        self.notes = notes
        self.amount = amount
        self.transactionType = transactionType
        self.transactionDate = transactionDate
        self.account = account
    }
}

enum TransactionType: String, Codable, CaseIterable, Identifiable {
    case Expense = "Expense"
    case Income = "Income"
    case Transfer = "Transfer"
    
    var id: TransactionType {
        self
    }
    
    var description: String {
        self.rawValue
    }
}
