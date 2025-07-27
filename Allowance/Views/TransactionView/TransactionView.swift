//
//  TransactionView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 27/7/2025.
//

import SwiftUI
import SwiftData

struct TransactionView: View {
    
    @Query private var transactions: [Transaction]
    
    @State private var newTransactionView: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(transactions) { transaction in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(transaction.title)
                                .font(.headline)
                            Text(transaction.account.name)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if transaction.transactionType == .Expense {
                            Text("- $" + String(transaction.amount))
                                .foregroundStyle(Color.red)
                        } else if transaction.transactionType == .Income {
                            Text("+ $" + String(transaction.amount))
                                .foregroundStyle(Color.green)
                        } else {
                            Text("$" + String(transaction.amount))
                                .foregroundStyle(Color.primary)
                        }
                    }
                }
            }
            .navigationTitle("Transactions")
          
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add New Transaction", systemImage: "plus") {
                        newTransactionView.toggle()
                    }
                }
            }
            .sheet(isPresented: $newTransactionView) {
                NewTransactionView()
            }
        }
    }
}




#Preview {
    TransactionView()
}
