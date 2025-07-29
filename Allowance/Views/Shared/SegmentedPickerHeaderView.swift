//
//  SegmentedPickerHeaderView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 29/7/2025.
//

import SwiftUI

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
