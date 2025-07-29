////
////  TransactionDetailView.swift
////  Allowance
////
////  Created by Shuvam Shrestha on 29/7/2025.
////
//
//import SwiftUI
//
//import SwiftData
//import SwiftUI
//
//struct TransactionDetailView: View {
//    
//    var transaction: Transaction
//    
//    @Query(sort: \Account.name) private var accounts: [Account]
//
//    @State private var notes: String = ""
//    @State private var amount: String = ""
//    @State private var transactionType: TransactionType = .Expense
//    @State private var transactionDate: Date = .now
//    @State private var account: Account?
//    @State private var transferAccount: Account?
//
//    @State private var showingDiscardAlert = false
//
//    @Environment(\.modelContext) private var modelContext
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        NavigationView {
//            Form {
//                Section {
//                    // Empty for now
//                } header: {
//                    SegmentedPickerHeaderView(transactionType: $transactionType)
//                }
//
//                Section(header: Text("Account Detail")) {
//                    if transactionType == .Expense {
//                        Picker("Source", selection: $account) {
//                            ForEach(accounts) { account in
//                                Text(account.name).tag(account as Account?)
//                            }
//                        }
//                    }
//
//                    if transactionType == .Income {
//                        Picker("Destination", selection: $account) {
//                            ForEach(accounts) { account in
//                                Text(account.name).tag(account as Account?)
//                            }
//                        }
//                    }
//                    
//                    if transactionType == .Transfer {
//                        Picker("Source", selection: $account) {
//                            ForEach(accounts) { account in
//                                Text(account.name).tag(account)
//                            }
//                        }
//                        Picker("Destination", selection: $transferAccount) {
//                            ForEach(accounts) { account in
//                                Text(account.name).tag(account)
//                            }
//                        }
//                    }
//                }
//
//                Section(header: Text("Transaction Information")) {
//                    HStack(spacing: 12) {
//                        icon("dollarsign")
//                        TextField("Transaction Amount", text: $amount)
//                            .keyboardType(.decimalPad)
//                    }
//
//                    HStack(spacing: 12) {
//                        icon("pencil.and.list.clipboard")
//                        TextField("Notes", text: $notes)
//                    }
//
//                    HStack(spacing: 12) {
//                        icon("calendar")
//                        DatePicker("Date", selection: $transactionDate, displayedComponents: .date)
//                    }
//                }
//            }
//            .navigationTitle("Add New Transaction")
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Save") {
//                        let finalNotes = notes.isEmpty ? "Unassigned" : notes
//                        guard let validAmount = Double(amount), let selectedAccount = account else { return }
//                        
//                        if transactionType == .Expense {
//                            var expenseTransaction = Transaction(
//                                notes: finalNotes,
//                                amount: validAmount,
//                                transactionType: transactionType,
//                                transactionDate: transactionDate,
//                            )
//                            
//                            expenseTransaction.sourceAccount = selectedAccount
//                            
//                            modelContext.insert(expenseTransaction)
//                            dismiss()
//                            
//                        } else if transactionType == .Income {
//                            var incomeTransaction = Transaction(
//                                notes: finalNotes,
//                                amount: validAmount,
//                                transactionType: transactionType,
//                                transactionDate: transactionDate,
//                                account: selectedAccount
//                            )
//                            
//                            expenseTransaction.sourceAccount = selectedAccount
//                            
//                            modelContext.insert(expenseTransaction)
//                            dismiss()
//                        }
//                        
//                    }
//                    .disabled(!isFormValid)
//                }
//
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        if hasUnsavedChanges {
//                            showingDiscardAlert = true
//                        } else {
//                            dismiss()
//                        }
//                    }
//                }
//            }
//            .onAppear {
//                self.account = transaction.account
//                if let transferAccount = transaction.account {
//                    self.transferAccount = transferAccount
//                } else {
//                    self.transferAccount = accounts.first
//                }
//                
//            }
//            .confirmationDialog("Unsaved Changes", isPresented: $showingDiscardAlert) {
//                Button("Discard Changes", role: .destructive) {
//                    dismiss()
//                }
//            }
//        }
//        .interactiveDismissDisabled(hasUnsavedChanges ? true : false)
//    }
//
//    // MARK: - Validation & Logic
//
//    private var isFormValid: Bool {
//        !notes.isEmpty &&
//        Double(amount) != nil &&
//        account != nil
//    }
//
//    private var hasUnsavedChanges: Bool {
//        !notes.isEmpty ||
//        !amount.isEmpty
//       
//    }
//
//    private func icon(_ systemName: String) -> some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 6)
//                .frame(width: 28, height: 28)
//                .foregroundStyle(Color.accentColor)
//            Image(systemName: systemName)
//                .font(.subheadline)
//                .foregroundStyle(Color.white)
//        }
//    }
//}
//
//
//
//
