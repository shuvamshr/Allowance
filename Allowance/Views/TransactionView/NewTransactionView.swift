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
    
    @State private var notes: String = ""
    @State private var amount: String = ""
    @State private var transactionType: TransactionType = .Expense
    @State private var transactionDate: Date = .now
    @State private var sourceAccount: Account?
    @State private var destinationAccount: Account?
    
    @State private var isValidTransactionAmount: Bool = true
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                   
                } header: {
                    SegmentedPickerHeaderView(transactionType: $transactionType)
                }
                
                Section {
                    if transactionType == .Expense {
                        Picker("Source Account", selection: $sourceAccount) {
                            ForEach(accounts) { sourceAccount in
                                Text(sourceAccount.name).tag(sourceAccount)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    } else if transactionType == .Income {
                        Picker("Destination Account", selection: $sourceAccount) {
                            ForEach(accounts) { sourceAccount in
                                Text(sourceAccount.name).tag(sourceAccount)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    } else if transactionType == .Transfer {
                        Picker("Destination Account", selection: $sourceAccount) {
                            ForEach(accounts) { sourceAccount in
                                Text(sourceAccount.name).tag(sourceAccount)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        Picker("To:", selection: $destinationAccount) {
                            ForEach(accounts) { destinationAccount in
                                Text(destinationAccount.name).tag(destinationAccount)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                    
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
                    
                    DatePicker("Transaction Date", selection: $transactionDate, displayedComponents: .date)
                }
                
            }
            .navigationTitle("Add New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                            let newTransaction = Transaction(notes: notes, amount: Double(amount)!, transactionType: transactionType, transactionDate: transactionDate, sourceAccount: sourceAccount!)
                            modelContext.insert(newTransaction)
                            dismiss()
                    }
                    .disabled(!isValidTransactionAmount && isFieldEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                self.sourceAccount = accounts.first
                self.destinationAccount = accounts.first
            }
        }
    }
    
    private var isFieldEmpty: Bool {
        if notes.isEmpty || amount.isEmpty {
            true
        } else {
            false
        }
    }
}


struct SegmentedPickerHeaderView: View {
    @Binding var transactionType: TransactionType

    var body: some View {
        HStack {
            Picker("Transaction Type", selection: $transactionType) {
                ForEach(TransactionType.allCases) { type in
                    Text(type.description).tag(type)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(.horizontal, -16) // Remove default header padding
        .padding(.vertical, 0)
        .textCase(nil) // Avoid uppercasing on text labels
    }
}
