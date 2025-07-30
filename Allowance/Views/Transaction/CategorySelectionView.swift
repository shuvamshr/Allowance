//
//  CategorySelectionView.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 30/7/2025.
//

import SwiftUI
import SwiftData

struct CategorySelectionView: View {
    
    @Query private var categories: [Category]
    
    @Binding var category: Category
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(categories) { category in
                HStack {
                    CategoryIconView(category: category)
                    Text(category.name)
                }
                .onTapGesture {
                    self.category = category
                    dismiss()
                }
            }
        }
        .navigationTitle("Select Category")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add New Category", systemImage: "plus") {
                    
                }
            }
        }
        .onAppear {
            populateCategory()
        }
    }
    
    private func populateCategory() {
        // Only populate if empty
        if categories.isEmpty {
            let defaultCategories = [
                Category(name: "Food", icon: "fork.knife", color: "blue"),
                Category(name: "Travel", icon: "airplane", color: "green"),
                Category(name: "Shopping", icon: "cart", color: "red"),
                Category(name: "Bills", icon: "creditcard", color: "orange"),
                Category(name: "Health", icon: "heart", color: "pink"),
                Category(name: "Entertainment", icon: "film", color: "purple")
            ]
            
            for category in defaultCategories {
                modelContext.insert(category)
            }
            
            // Save the context so @Query updates
            try? modelContext.save()
        }
    }
}

struct CategoryIconView: View {
    var category: Category
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .frame(width: 28, height: 28)
                .foregroundStyle(colorFromString(category.color)) // Use color from model
            
            Image(systemName: category.icon)
                .font(.subheadline)
                .foregroundStyle(.white)
        }
    }
    
    /// Convert stored string to SwiftUI Color
    private func colorFromString(_ colorName: String) -> Color {
        switch colorName.lowercased() {
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "orange": return .orange
        case "pink": return .pink
        case "purple": return .purple
        default: return .gray // Fallback
        }
    }
}



struct NewCategoryView: View {
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var color: Color = .blue
    
    var body: some View {
        Form {
            TextField("Category Name", text: $name)
            
            ColorPicker("Select Category Color", selection: $color)
            
            TextField("Select Icon (SF Symbol)", text: $icon)
                .keyboardType(.asciiCapable)
        }
    }
    
    /// Convert SwiftUI Color to String before saving
    private func colorToString(_ color: Color) -> String {
        switch color {
        case .blue: return "blue"
        case .green: return "green"
        case .red: return "red"
        case .orange: return "orange"
        case .pink: return "pink"
        case .purple: return "purple"
        default: return "gray"
        }
    }
}

//#Preview {
//    NavigationView {
//        CategorySelectionView()
//    }
//}
