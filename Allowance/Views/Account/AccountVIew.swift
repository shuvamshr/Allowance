//
//  AccountVIew.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 25/7/2025.
//

import SwiftUI
import SwiftData

struct AccountView: View {
    
    @Query(sort: [SortDescriptor(\Account.creationDate, order: .reverse)]) private var accounts: [Account]
    
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
                            Text("\(account.netBalance, format: .currency(code: "AUD"))")
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
            .navigationTitle("Accounts")
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




#Preview {
    AccountView()
}
