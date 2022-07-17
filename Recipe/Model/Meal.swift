//
//  Meal.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import Foundation

struct MealsWrapper: Codable {
    var meals: [Meal]?
}

extension MealsWrapper: Hashable {}

struct Meal: Codable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
    var ingredients: [Ingredient]? = nil
}

extension Meal: Hashable {}

extension Meal {
    static let MOCK = Meal(strMeal: "Three Fish Pie", strMealThumb: "https://www.themealdb.com/images/media/meals/spswqs1511558697.jpg", idMeal: "52882")
}
