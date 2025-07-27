//
//  AccountVIew.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 25/7/2025.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    
    @Query(sort: [SortDescriptor(\Account.creationDate, order: .reverse)]) private var accounts: [Account] = []
    
    @State private var newAccountView: Bool = false
    @State private var selectedAccount: Account?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(accounts) { account in
                    HStack(spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(account.name)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("$" + String(account.balance))
                                .font(.title2)
                            
                        }
                        Spacer()
                        Image(systemName: "australiandollarsign.bank.building.fill")
                            .foregroundStyle(Color.white)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 36, height: 36)
                                    .foregroundStyle(Color.accentColor)
                            }
                            .onTapGesture {
                                selectedAccount = account
                            }
                    }
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                }
            }
            .navigationTitle("My Accounts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Wallet", systemImage: "plus") {
                        newAccountView.toggle()
                    }
                }
            }
            .sheet(isPresented: $newAccountView) {
                NewAccountView()
            }
            .sheet(item: $selectedAccount) { account in
                EditAccountView(account: account)
            }
        }
    }
}


struct NewAccountView: View {
    
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
                            if let balance = Double(balance) {
                                isValidBalance = true
                            } else {
                                isValidBalance = false
                            }
                        }
                } header: {
                    Text("Account Information")
                }
            }
            .navigationTitle("Add New Account")
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
                            modelContext.insert(Account(name: name, balance: balance))
                            dismiss()
                        }
                    }
                    .disabled(!isFieldEmpty && isValidBalance ? false : true)
                }
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
    
    
}

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
                            if let balance = Double(balance) {
                                isValidBalance = true
                            } else {
                                isValidBalance = false
                            }
                        }
                } header: {
                    Text("Account Information")
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
                    .disabled(!isFieldEmpty && isValidBalance ? false : true)
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
    
    
}


#Preview {
    AccountView()
}
