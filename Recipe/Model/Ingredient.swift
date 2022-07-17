//
//  Ingredient.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import Foundation

protocol IngredientProtocol: Decodable {
    var ingredient: String { get set }
    var measurement: String { get set }
}

struct Ingredient: Codable {
    var ingredient: String
    var measurement: String
    
    func toEntity() -> IngredientEntity {
        let ingredient = IngredientEntity(context: PersistenceController.shared.container.viewContext)
        ingredient.ingredient = self.ingredient
        ingredient.measurement = self.measurement
        return ingredient
    }
}

extension Ingredient: Hashable {}

