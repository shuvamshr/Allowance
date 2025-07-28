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
                            Text(transaction.notes)
                                .font(.headline)
                            Text(transaction.account.name)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                       
                        Text("\(transaction.amount, format: .currency(code: "AUD"))")
                                .foregroundStyle(Color.red)
                        
                           
                       
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
