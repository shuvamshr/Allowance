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
                    TextField("Starting Balance", text: $balance)
                        .keyboardType(.decimalPad)
                        .onChange(of: balance) {
                            isValidBalance = Double(balance) != nil
                        }
                } header: {
                    Text("Account Information")
                }
                
                Section(header: Text("Latest Transactions")) {
                    ForEach(account.allTransactions.sorted(by: { $0.transactionDate > $1.transactionDate })) { transaction in
                        // Only show transactions involving this account
                        if transaction.sourceAccount == account || transaction.destinationAccount == account {
                            TransactionListItem(transaction: transaction)
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
                            account.name = name
                            account.balance = newBalance
                            account.creationDate = .now
                            dismiss()
                        }
                    }
                    .disabled(!canSave)
                }
            }
            .onAppear {
                self.name = account.name
                self.balance = String(account.balance)
            }
        }
    }
    
    // MARK: - Validation
    
    private var isFieldEmpty: Bool {
        name.isEmpty || balance.isEmpty
    }
    
    private var hasFieldChanged: Bool {
        name != account.name || Double(balance) != account.balance
    }
    
    private var canSave: Bool {
        !isFieldEmpty && isValidBalance && hasFieldChanged
    }
}
