//
//  RecipeView.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import SwiftUI
import CoreData
import NukeUI

struct RecipeView: View {
    
    @StateObject var vm: ViewModel
    
    var body: some View {
        List {
            Section {
                LazyImage(source: vm.meal.strMealThumb, resizingMode: .aspectFit)
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
        .navigationTitle(vm.meal.strMeal)
        .toolbar {
            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                Button {
                    vm.shouldSave.toggle()
                } label: {
                    Image(systemName: vm.shouldSave ? "star.fill" : "star")
                }
            }
        }
        .task {
            await vm.getIngredients(mealId: vm.meal.idMeal)
        }
        .onDisappear {
            vm.handleSaveOrUnsave()
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RecipeView(vm: .init(meal: .MOCK))
        }
    }
}

extension RecipeView {
    class ViewModel: ObservableObject {
        
        @Published var recipe: Recipe?
        
        @Published var recipeEntity: RecipeEntity?
        
        @Published var shouldSave: Bool = false
        
        let meal: Meal
        
        private let network: NetworkProtocol
        
        private let context: NSManagedObjectContext
        
        deinit {
            print("Deinited - RecipeView")
        }
        
        init(
            meal: Meal,
            recipe: Recipe? = nil,
            entity: RecipeEntity? = nil,
            network: NetworkProtocol = DefaultNetworkService.shared,
            context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
        ) {
            self.meal = meal
            self.recipeEntity = entity
            self.network = network
            self.context = context
            if let recipe = recipe {
                self.recipe = recipe
                self.shouldSave = true
            }
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
        
        func handleSaveOrUnsave() {
            if shouldSave, let recipe = recipe, recipeEntity == nil {
                _ = recipe.toEntity()
            } else if let recipeEntity = recipeEntity {
                context.delete(recipeEntity)
            }
            withAnimation {
                try? context.save()
            }
        }
    }
}
