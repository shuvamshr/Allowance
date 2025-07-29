//
//  TransactionView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 27/7/2025.
//

import SwiftUI
import SwiftData


struct TransactionView: View {
    
    @Query(sort: \Transaction.transactionDate, order: .reverse)
    private var transactions: [Transaction]
    
    @State private var newTransactionView: Bool = false
    
    // Group transactions by just the calendar day
    private var groupedTransactions: [(key: Date, value: [Transaction])] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: transactions) { transaction in
            calendar.startOfDay(for: transaction.transactionDate)
        }
        
        return grouped.sorted { $0.key > $1.key } // Newest date first
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedTransactions, id: \.key) { date, transactions in
                    Section(header: Text(date.formatted(date: .long, time: .omitted))) {
                        ForEach(transactions) { transaction in
                            TransactionListItem(transaction: transaction)
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
