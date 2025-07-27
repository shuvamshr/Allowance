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
    var type: TransactionType
    var date: Date
    var account: Account
    
    init(title: String, notes: String, amount: Double, type: TransactionType, date: Date, account: Account) {
        self.title = title
        self.notes = notes
        self.amount = amount
        self.type = type
        self.date = date
        self.account = account
    }
}

enum TransactionType: String, Codable {
    case Expense, Income, Transfer
}
