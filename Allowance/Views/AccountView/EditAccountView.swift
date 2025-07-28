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
                            if Double(balance) != nil {
                                isValidBalance = true
                            } else {
                                isValidBalance = false
                            }
                        }
                } header: {
                    Text("Account Information")
                }
                
                Section {
                    ForEach(account.transactions) { transaction in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(transaction.notes)
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
                } header: {
                    Text("Latest Transactions")
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
                        if let balance = Double(balance) {
                            account.name = name
                            account.balance = balance
                            account.creationDate = .now
                            dismiss()
                        }
                    }
                    .disabled(!isFieldEmpty && isValidBalance && hasFieldChanged ? false : true)
                }
            }
            .onAppear {
                self.name = account.name
                self.balance = String(account.balance)
                
            }
        }
        
    }
    
    private var isFieldEmpty: Bool {
        if name.isEmpty || balance.isEmpty {
            true
        } else {
            false
        }
    }
    
    private var hasFieldChanged: Bool {
        if name != account.name || Double(balance) != account.balance {
            true
        } else {
            false
        }
    }
}
