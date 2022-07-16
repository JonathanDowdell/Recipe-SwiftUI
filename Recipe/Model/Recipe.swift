//
//  Recipe.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import Foundation

struct RecipeWrapper: Decodable {
    var meals: [Recipe]?
    var data: Data?
}

extension RecipeWrapper: Hashable {}

struct Recipe: Decodable {
    var idMeal: String?
    var strMeal: String?
    var strDrinkAlternate: String?
    var strCategory: String?
    var strArea: String?
    var strInstructions: String?
    var strMealThumb: String?
    var strTags: String?
    var strYoutube: String?
    var strSource: String?
    var strImageSource: String?
    var strCreativeCommonsConfirmed: String?
    var ingredients: [Ingredient]? = .init()
    var dateModified: String?
}

extension Recipe: Hashable {}

extension Recipe {
    static let MOCK = Recipe(idMeal: "52882", strMeal: "Three Fish Pie", strDrinkAlternate: nil, strCategory: "Seafood", strArea: "British", strInstructions: "Preheat the oven to 200C/400F/Gas 6 (180C fan).\r\nPut the potatoes into a saucepan of cold salted water. Bring up to the boil and simmer until completely tender. Drain well and then mash with the butter and milk. Add pepper and taste to check the seasoning. Add salt and more pepper if necessary.\r\nFor the fish filling, melt the butter in a saucepan, add the leeks and stir over the heat. Cover with a lid and simmer gently for 10 minutes, or until soft. Measure the flour into a small bowl. Add the wine and whisk together until smooth.\r\nAdd the milk to the leeks, bring to the boil and then add the wine mixture. Stir briskly until thickened. Season and add the parsley and fish. Stir over the heat for two minutes, then spoon into an ovenproof casserole. Scatter over the eggs. Allow to cool until firm.\r\nSpoon the mashed potatoes over the fish mixture and mark with a fork. Sprinkle with cheese.\r\nBake for 30-40 minutes, or until lightly golden-brown on top and bubbling around the edges.", strMealThumb: "https://www.themealdb.com/images/media/meals/spswqs1511558697.jpg", strTags: "Fish,Seafood,Dairy,Pie", strYoutube: "https://www.youtube.com/watch?v=Ds1Jb8H5Sg8", strSource: "https://www.bbc.co.uk/food/recipes/three_fish_pie_58875", strImageSource: nil, strCreativeCommonsConfirmed: nil, ingredients: .init(), dateModified: nil)
}
