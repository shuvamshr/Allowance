//
//  NewTransactionView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 28/7/2025.
//

import SwiftData
import SwiftUI

struct NewTransactionView: View {
    @Query(sort: \Account.name) private var accounts: [Account]
    
    @State private var notes: String = ""
    @State private var amount: String = ""
    @State private var transactionType: TransactionType = .Expense
    @State private var transactionDate: Date = .now
    @State private var sourceAccount: Account?
    @State private var destinationAccount: Account?
    
    @State private var showingDiscardAlert = false
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                
                Section {
                    // Placeholder for segmented control
                } header: {
                    SegmentedPickerHeaderView(transactionType: $transactionType)
                }
                
                Section {
                    HStack(spacing: 8) {
                        Text("$")
                            .font(.largeTitle)
                        TextField("0.00", text: $amount)
                            .font(.largeTitle)
                            .keyboardType(.decimalPad)
                        
                    }
                    HStack(spacing: 12) {
                        icon("pencil.and.list.clipboard")
                        TextField("Notes", text: $notes)
                    }
                } header: {
                    EmptyView()
                } footer: {
                    EmptyView()
                }
                
                Section {
                    switch transactionType {
                    case .Expense:
                        HStack(spacing: 12) {
                            icon("minus.circle")
                            Picker("Source", selection: $sourceAccount) {
                                ForEach(accounts) { account in
                                    Text(account.name).tag(account as Account?)
                                }
                            }
                        }
                    case .Income:
                        HStack(spacing: 12) {
                            icon("plus.circle.fill")
                            Picker("Destination", selection: $destinationAccount) {
                                ForEach(accounts) { account in
                                    Text(account.name).tag(account)
                                }
                            }
                        }
                        
                    case .Transfer:
                        HStack(spacing: 12) {
                            icon("minus.circle")
                            Picker("Source", selection: $sourceAccount) {
                                ForEach(accounts) { account in
                                    Text(account.name).tag(account)
                                }
                            }
                        }

                        HStack(spacing: 12) {
                            icon("plus.circle.fill")
                            Picker("Destination", selection: $destinationAccount) {
                                ForEach(accounts) { account in
                                    Text(account.name).tag(account)
                                }
                            }
                            .disabled(accounts.count == 1) // Disable if only one account
                        }
                    }
                } header: {
                    
                } footer: {
                    if accounts.isEmpty {
                        Text("You do not have any accounts. Please create one to add transactions.")
                            .foregroundStyle(.red)
                    } else if transactionType == .Transfer && accounts.count == 1 {
                        Text("You only have one account. Please add one more to add transfer transactions.")
                            .foregroundStyle(.red)
                    } else if transactionType == .Transfer && sourceAccount == destinationAccount {
                        Text("Source and Destination Account cannot be the same.")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    HStack(spacing: 12) {
                        icon("calendar")
                        DatePicker("Date", selection: $transactionDate, displayedComponents: .date)
                    }
                    HStack(spacing: 12) {
                        icon("pencil.and.list.clipboard")
                        TextField("Select Budget", text: $notes)
                    }
                    HStack(spacing: 12) {
                        icon("pencil.and.list.clipboard")
                        TextField("Notes", text: $notes)
                    }
                    
                    
                } header: {
                    Text("Transaction Detail")
                } footer: {
                    EmptyView()
                }
                
            }
            .listSectionSpacing(16)
            .navigationTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalNotes = notes.isEmpty ? "Unassigned" : notes
                        guard let amountValue = Double(amount) else { return }
                        
                        let transaction = Transaction(
                            notes: finalNotes,
                            amount: amountValue,
                            transactionType: transactionType,
                            transactionDate: transactionDate
                        )
                        
                        switch transactionType {
                        case .Expense:
                            transaction.sourceAccount = sourceAccount
                            
                        case .Income:
                            transaction.destinationAccount = destinationAccount
                            
                        case .Transfer:
                            transaction.sourceAccount = sourceAccount
                            transaction.destinationAccount = destinationAccount
                        }
                        
                        modelContext.insert(transaction)
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        if hasUnsavedChanges {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                }
            }
            .onAppear {
                self.sourceAccount = accounts.first
                self.destinationAccount = accounts.first
            }
            .confirmationDialog("Unsaved Changes", isPresented: $showingDiscardAlert) {
                Button("Discard Changes", role: .destructive) {
                    dismiss()
                }
            }
        }
        .interactiveDismissDisabled(hasUnsavedChanges)
    }
    
    // MARK: - Validation & Logic
    
    private var isFormValid: Bool {
        guard Double(amount) != nil else { return false }
        
        switch transactionType {
        case .Expense:
            return sourceAccount != nil
        case .Income:
            return destinationAccount != nil
        case .Transfer:
            return sourceAccount != nil && destinationAccount != nil && sourceAccount != destinationAccount
        }
    }
    
    private var hasUnsavedChanges: Bool {
        !notes.isEmpty || !amount.isEmpty
    }
    
    private func icon(_ systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 20, height: 20)
                .opacity(0)
            Image(systemName: systemName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
