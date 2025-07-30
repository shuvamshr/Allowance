//
//  TransactionListItem.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 29/7/2025.
//


import SwiftUI

struct TransactionListItem: View {
    var transaction: Transaction
    
    var showDate: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(transaction.notes)
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 2) {
                    accountNameView
                    if showDate {
                        Text(transaction.transactionDate.formatted(date: .numeric, time: .omitted))
                    }
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 4) {
                Text("\(transaction.amount, format: .currency(code: "AUD"))")
                    .font(.subheadline)
                Image(systemName: iconName)
                    .font(.caption)
            }
            .foregroundStyle(iconColor)
        }
        .padding(.vertical, 2)
    }

    private var iconName: String {
        switch transaction.transactionType {
        case .Expense:
            return "arrowtriangle.down.fill"
        case .Income:
            return "arrowtriangle.up.fill"
        case .Transfer:
            return "arrow.left.arrow.right"
        }
    }

    private var iconColor: Color {
        switch transaction.transactionType {
        case .Expense:
            return .red
        case .Income:
            return .green
        case .Transfer:
            return .orange
        }
    }

    @ViewBuilder
    private var accountNameView: some View {
        switch transaction.transactionType {
        case .Expense:
            Text("\(transaction.sourceAccount?.name ?? "Unknown")")
        case .Income:
            Text("\(transaction.destinationAccount?.name ?? "Unknown")")
        case .Transfer:
            VStack(alignment: .leading, spacing: 2) {
                Text("\(transaction.sourceAccount?.name ?? "Unknown")")
                HStack(spacing: 2) {
                    Image(systemName: "arrow.turn.down.right")
                    Text("\(transaction.destinationAccount?.name ?? "Unknown")")
                }
                
            }
        }
    }
}
