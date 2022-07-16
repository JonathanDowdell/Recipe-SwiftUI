//
//  RecipeView.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import SwiftUI
import NukeUI

struct RecipeView: View {
    
    let meal: Meal
    
    @StateObject var vm: ViewModel = .init()
    
    var body: some View {
        List {
            Section {
                LazyImage(source: meal.strMealThumb, resizingMode: .aspectFit)
                    .frame(height: 200, alignment: .center)
                    .cornerRadius(10)
            }
            
            if let recipe = vm.recipe {
                Section {
                    Text(recipe.strInstructions ?? "")
                } header: {
                    Text("Instructions")
                }
            }
            
            Section {
                ForEach(vm.recipe?.ingredients ?? .init(), id: \.self) { ingredient in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(ingredient.ingredient)
                        
                        Text(ingredient.measurement)
                            .font(.caption)
                    }
                    .padding(.vertical, 5)
                }
            } header: {
                Text("Ingredients")
            }


        }
        .navigationTitle(meal.strMeal)
        .task {
            await vm.getIngredients(mealId: meal.idMeal)
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeView(meal: .MOCK)
        }
    }
}

extension RecipeView {
    class ViewModel: ObservableObject {
        
        @Published var recipe: Recipe?
        
        private let network: NetworkProtocol
        
        init(
            network: NetworkProtocol = DefaultNetworkService.shared
        ) {
            self.network = network
        }
        
        @MainActor
        func getIngredients(mealId: String) async {
            let recipeRequest = RecipeRequest(apiKey: "1", recipeId: mealId)
            do {
                let recipeResponse = try await network.request(recipeRequest)
                if let recipe = recipeResponse.meals?.first {
                    withAnimation {
                        self.recipe = recipe
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
