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
