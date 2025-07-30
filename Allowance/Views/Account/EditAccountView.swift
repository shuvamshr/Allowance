//
//  EditAccountView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 28/7/2025.
//

import SwiftData
import SwiftUI

struct EditAccountView: View {
    
    @Bindable var account: Account
    @State private var name: String = ""
    @State private var balance: String = ""
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var isValidBalance: Bool = true

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Account Name", text: $name)
                    TextField("Net Balance", text: $balance)
                        .keyboardType(.decimalPad)
                        .onChange(of: balance) {
                            isValidBalance = Double(balance) != nil
                        }
                } header: {
                    Text("Account Information")
                }
                
                Section(header: Text("Latest Transactions")) {
                    ForEach(account.allTransactions) { transaction in
                        if transaction.sourceAccount == account || transaction.destinationAccount == account {
                            TransactionListItem(transaction: transaction, showDate: true)
                        }
                    }
                }
            }
            .navigationTitle("Edit Account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let newBalance = Double(balance) {
                            let delta = newBalance - account.netBalance
                            if delta != 0 {
                                var transaction = Transaction(
                                    notes: "Balance Correction",
                                    amount: abs(delta),
                                    transactionType: delta > 0 ? .Income : .Expense,
                                    transactionDate: .now
                                )
                                if delta > 0 {
                                    transaction.destinationAccount = account
                                } else {
                                    transaction.sourceAccount = account
                                }
                                modelContext.insert(transaction)
                            }

                            account.name = name
                            account.creationDate = .now
                            dismiss()
                        }
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                self.name = account.name
                self.balance = String(format: "%.2f", account.netBalance)
            }
        }
    }
    
    private var isFieldEmpty: Bool {
        name.isEmpty || balance.isEmpty
    }

    private var hasFieldChanged: Bool {
        name != account.name || Double(balance) != account.netBalance
    }

    private var canSave: Bool {
        !isFieldEmpty && isValidBalance && hasFieldChanged
    }
}
