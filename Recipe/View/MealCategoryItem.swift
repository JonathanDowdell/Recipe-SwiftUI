//
//  MealCategoryItem.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import SwiftUI
import NukeUI

struct MealCategoryItem: View {
    
    let meal: Meal
    
    var body: some View {
        HStack {
            LazyImage(source: meal.strMealThumb, resizingMode: .aspectFit)
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(10)

            VStack(alignment: .leading) {
                Text(meal.strMeal)
                    .font(.title3)
                    .padding(.leading)
                
                Text(meal.idMeal)
                    .foregroundColor(.secondary)
                    .font(.caption)
                    .padding(.leading)
            }
        }
        .padding(.vertical, 3)
    }
}

struct MealCategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                MealCategoryItem(meal: Meal.MOCK)
                MealCategoryItem(meal: Meal.MOCK)
            }
            .navigationTitle("Beef")
        }
    }
}
