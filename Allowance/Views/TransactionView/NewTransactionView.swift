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
    @State private var account: Account?
    @State private var transferAccount: Account?

    @State private var showingDiscardAlert = false

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Empty for now
                } header: {
                    SegmentedPickerHeaderView(transactionType: $transactionType)
                }

                Section(header: Text("Account Detail")) {
                    if transactionType == .Expense {
                        Picker("Source", selection: $account) {
                            ForEach(accounts) { account in
                                Text(account.name).tag(account as Account?)
                            }
                        }
                    }

                    if transactionType == .Income {
                        Picker("Destination", selection: $account) {
                            ForEach(accounts) { account in
                                Text(account.name).tag(account as Account?)
                            }
                        }
                    }
                    
                    if transactionType == .Transfer {
                        Picker("Source", selection: $account) {
                            ForEach(accounts) { account in
                                Text(account.name).tag(account)
                            }
                        }
                        Picker("Destination", selection: $transferAccount) {
                            ForEach(accounts) { account in
                                Text(account.name).tag(account)
                            }
                        }
                    }
                }

                Section(header: Text("Transaction Information")) {
                    HStack(spacing: 12) {
                        icon("dollarsign")
                        TextField("Transaction Amount", text: $amount)
                            .keyboardType(.decimalPad)
                    }

                    HStack(spacing: 12) {
                        icon("pencil.and.list.clipboard")
                        TextField("Notes", text: $notes)
                    }

                    HStack(spacing: 12) {
                        icon("calendar")
                        DatePicker("Date", selection: $transactionDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Add New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalNotes = notes.isEmpty ? "Unassigned" : notes
                        guard let validAmount = Double(amount), let selectedAccount = account else { return }
                        
                        if transactionType == .Expense || transactionType == .Income {
                            let newTransaction = Transaction(
                                notes: finalNotes,
                                amount: validAmount,
                                transactionType: transactionType,
                                transactionDate: transactionDate,
                                account: selectedAccount
                            )

                            modelContext.insert(newTransaction)
                            dismiss()
                            
                        } else if transactionType == .Transfer {
                            let expenseTransaction = Transaction(
                                notes: finalNotes,
                                amount: validAmount,
                                transactionType: transactionType,
                                transactionDate: transactionDate,
                                account: account
                            )

                            modelContext.insert(newTransaction)
                            dismiss()
                        }
                        
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
                self.account = accounts.first
                self.transferAccount = accounts.first
            }
            .confirmationDialog("Unsaved Changes", isPresented: $showingDiscardAlert) {
                Button("Discard Changes", role: .destructive) {
                    dismiss()
                }
            }
        }
        .interactiveDismissDisabled(hasUnsavedChanges ? true : false)
    }

    // MARK: - Validation & Logic

    private var isFormValid: Bool {
        !notes.isEmpty &&
        Double(amount) != nil &&
        account != nil
    }

    private var hasUnsavedChanges: Bool {
        !notes.isEmpty ||
        !amount.isEmpty
       
    }

    private func icon(_ systemName: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 28, height: 28)
                .foregroundStyle(Color.accentColor)
            Image(systemName: systemName)
                .font(.subheadline)
                .foregroundStyle(Color.white)
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
