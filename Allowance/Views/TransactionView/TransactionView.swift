//
//  TransactionView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 27/7/2025.
//

import SwiftUI
import SwiftData

struct TransactionView: View {
    
    @Query private var transactions: [Transaction] = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(transactions) { transaction in
                    HStack {
                        Text(transaction.title)
                        Spacer()
                        Text(String(transaction.amount))
                    }
                }
            }
            .navigationTitle("Transactions")
        }
    }
}

#Preview {
    TransactionView()
}
