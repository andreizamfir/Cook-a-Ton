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
        case title = "title"
        case image = "image"
        case readyInMinutes, servings
        case extendedIngredients
    }
}

struct Ingredient: Codable {
    let name, image: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case image = "image"
    }
    
}
