//
//  RecipeEntity+CoreDataProperties.swift
//  Recipe
//
//  Created by Mettaworldj on 7/16/22.
//
//

import Foundation
import CoreData


extension RecipeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeEntity> {
        return NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
    }

    @NSManaged public var idMeal: String?
    @NSManaged public var strMeal: String?
    @NSManaged public var strDrinkAlternate: String?
    @NSManaged public var strCategory: String?
    @NSManaged public var strArea: String?
    @NSManaged public var strInstructions: String?
    @NSManaged public var strMealThumb: String?
    @NSManaged public var strTags: String?
    @NSManaged public var strYoutube: String?
    @NSManaged public var strSource: String?
    @NSManaged public var strImageSource: String?
    @NSManaged public var strCreativeCommonsConfirmed: String?
    @NSManaged public var dateModified: Date?
    @NSManaged public var raw_ingredients: NSSet?
    
    var ingredients: [IngredientEntity] {
        let set = raw_ingredients as? Set<IngredientEntity> ?? .init()
        return set.sorted { $0.ingredient ?? "" < $1.ingredient ?? "" }
    }

    func toMeal() -> Meal {
        return Meal(strMeal: strMeal ?? "", strMealThumb: strMealThumb ?? "", idMeal: idMeal ?? "")
    }
    
    func toRecipe() -> Recipe {
        return Recipe(idMeal: idMeal, strMeal: strMeal, strDrinkAlternate: strDrinkAlternate, strCategory: strCategory, strArea: strArea, strInstructions: strInstructions, strMealThumb: strMealThumb, strTags: strTags, strYoutube: strYoutube, strSource: strSource, strImageSource: strImageSource, strCreativeCommonsConfirmed: strCreativeCommonsConfirmed, ingredients: ingredients.map { $0.toIngredient() }, dateModified: nil)
    }
}

// MARK: Generated accessors for raw_ingredients
extension RecipeEntity {
    
    func addToIngredients(_ value: IngredientEntity) {
        self.addToRaw_ingredients(value)
    }
    
    func addToIngredients(contentsOf values: [IngredientEntity]) {
        for value in values {
            self.addToIngredients(value)
        }
    }

    @objc(addRaw_ingredientsObject:)
    @NSManaged public func addToRaw_ingredients(_ value: IngredientEntity)

    @objc(removeRaw_ingredientsObject:)
    @NSManaged public func removeFromRaw_ingredients(_ value: IngredientEntity)

    @objc(addRaw_ingredients:)
    @NSManaged public func addToRaw_ingredients(_ values: NSSet)

    @objc(removeRaw_ingredients:)
    @NSManaged public func removeFromRaw_ingredients(_ values: NSSet)

}

extension RecipeEntity : Identifiable {

}
