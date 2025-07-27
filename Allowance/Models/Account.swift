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
    var balance: Double
    var creationDate: Date
    var transactions: [Transaction] = []
    
    init(name: String, balance: Double, date: Date = .now) {
        self.name = name
        self.balance = balance
        self.creationDate = date
    }
    
    var totalBalance: Double {
        var total = 0.0
        
        for transaction in transactions {
            total += transaction.amount
        }
        
        return total
    }
}
