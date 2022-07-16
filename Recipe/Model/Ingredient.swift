//
//  Ingredient.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import Foundation

struct Ingredient: Decodable {
    let ingredient: String
    let measurement: String
}

extension Ingredient: Hashable {}
