//
//  TransactionListItem.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 29/7/2025.
//


import SwiftUI

struct TransactionListItem: View {
    var transaction: Transaction

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(transaction.notes)
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(accountDisplayName)
                    Text(transaction.transactionDate.formatted(date: .numeric, time: .omitted))
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

    private var accountDisplayName: String {
        switch transaction.transactionType {
        case .Transfer:
            let source = transaction.sourceAccount?.name ?? "Unknown"
            let destination = transaction.destinationAccount?.name ?? "Unknown"
            return "\(source) > \(destination)"
        case .Expense:
            return transaction.sourceAccount?.name ?? "Unknown"
        case .Income:
            return transaction.destinationAccount?.name ?? "Unknown"
        }
    }
}
