//
//  IngredientEntity+CoreDataProperties.swift
//  Recipe
//
//  Created by Mettaworldj on 7/16/22.
//
//

import Foundation
import CoreData


extension IngredientEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<IngredientEntity> {
        return NSFetchRequest<IngredientEntity>(entityName: "IngredientEntity")
    }

    @NSManaged public var ingredient: String?
    @NSManaged public var measurement: String?
    @NSManaged public var recipe: RecipeEntity?

    func toIngredient() -> Ingredient {
        return Ingredient(ingredient: ingredient ?? "", measurement: measurement ?? "")
    }
}

extension IngredientEntity : Identifiable {

}
