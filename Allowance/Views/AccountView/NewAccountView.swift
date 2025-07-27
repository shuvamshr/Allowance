//
//  NewAccountView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 28/7/2025.
//

import SwiftData
import SwiftUI

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
