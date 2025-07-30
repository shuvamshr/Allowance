//
//  Category.swift
//  Allowance
//
//  Created by Shuvam Shrestha on 30/7/2025.
//

import SwiftUI
import SwiftData

@Model
class Category {
    var name: String
    var icon: String
    var color: String
    
    init(name: String, icon: String, color: String) {
        self.name = name
        self.icon = icon
        self.color = color
    }
}
