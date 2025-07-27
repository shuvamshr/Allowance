//
//  NewTransactionView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 28/7/2025.
//

import SwiftData
import SwiftUI


struct NewTransactionView: View {
    
    @Query(sort: \Account.name) private var accounts: [Account] = []
    
    @State private var title: String = ""
    @State private var notes: String = ""
    @State private var amount: String = ""
    @State private var transactionType: TransactionType = .Expense
    @State private var transactionDate: Date = .now
    @State private var account: Account?
    
    @State private var isValidTransactionAmount: Bool = true
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Notes", text: $notes)
                }
                Section {
                    TextField("Transaction Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .onChange(of: amount) {
                        if let amount = Double(amount) {
                            isValidTransactionAmount = true
                        } else {
                            isValidTransactionAmount = false
                        }
                    }
                    Picker("Transaction Type", selection: $transactionType) {
                        ForEach(TransactionType.allCases) { transactionType in
                            Text(transactionType.description).tag(transactionType)
                        }
                    }
                    DatePicker("Transaction Date", selection: $transactionDate, displayedComponents: .date)
                }
                Section {
                    Picker("Select Account", selection: $account) {
                        ForEach(accounts) { account in
                            Text(account.name).tag(account)
                        }
                    }
                }
            }
            .navigationTitle("Add New Transaction")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let account = account {
                            modelContext.insert(Transaction(title: title, notes: notes, amount: Double(amount)!, transactionType: transactionType, transactionDate: transactionDate, account: account))
                            dismiss()
                        }
                    }
                    .disabled(!isValidTransactionAmount && isFieldEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var isFieldEmpty: Bool {
        if title.isEmpty || amount.isEmpty || account == nil {
            true
        } else {
            false
        }
    }
}
