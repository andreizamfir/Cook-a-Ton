//
//  Recipe.swift
//  Cook-a-Ton
//
//  Created by Andrei Zamfir on 11.09.2023.
//

import Foundation

struct Recipe: Codable {
    let recipes: [RecipeData]
}

struct RecipeData: Codable {
    let id: Double
    let title, image: String
    let readyInMinutes, servings: Int
    let extendedIngredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case image
        case readyInMinutes
        case servings
        case extendedIngredients
    }
}

struct Ingredient: Codable {
    let uuid = UUID()
    
    let name, unit: String
    let amount: Double
    
    enum CodingKeys: String, CodingKey {
        case name
        case unit
        case amount
    }
    
}

// Make sure the compiler identifies the unique items correctly
extension Ingredient: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.uuid)
    }

    public static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.uuid == rhs.uuid
    }

}
