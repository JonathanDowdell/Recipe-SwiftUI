//
//  CategoryView.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import SwiftUI
import CoreData

struct CategoryView: View {
    
    @StateObject private var vm = ViewModel()
    
    @FetchRequest(entity: RecipeEntity.entity(), sortDescriptors: [])
    var favoriteRecipes: FetchedResults<RecipeEntity>
    
    @StateObject var delayedTextSearch = DelayedTextObject()
    
    var body: some View {
        NavigationView {
            List {
                // Meals
                if vm.meals.count > 0 {
                    Section {
                        ForEach(vm.meals, id: \.self) { meal in
                            NavigationLink {
                                RecipeView(vm: .init(meal: meal))
                            } label: {
                                MealCategoryItem(meal: meal)
                            }
                        }
                    } header: {
                        Text("Meals")
                    }
                }
                
                // Favorites
                if favoriteRecipes.count > 0 {
                    Section {
                        ForEach(favoriteRecipes, id: \.self) { mealEntity in
                            let meal = mealEntity.toMeal()
                            NavigationLink {
                                RecipeView(vm:
                                        .init(
                                            meal: meal,
                                            recipe: mealEntity.toRecipe(),
                                            entity: mealEntity
                                        )
                                )
                            } label: {
                                MealCategoryItem(meal: meal)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                vm.deleteSavedRecipe(favoriteRecipes[index])
                            }
                        }
                    } header: {
                        Text("Favorite")
                    }

                }
                
                // Categories
                Section {
                    ForEach(vm.categories, id: \.self) { category in
                        NavigationLink {
                            MealsCategoryView(category: category)
                        } label: {
                            CategoryItem(category: category)
                        }
                    }
                } header: {
                    Text("Categories")
                }
                
            }
            .navigationTitle("Recipes")
            .searchable(text: $delayedTextSearch.text)
            .disableAutocorrection(true)
        }
        .task {
            do {
                try await vm.getCategories()
            } catch {
                print(error)
            }
        }
        .onChange(of: delayedTextSearch.debouncedText) { text in
            Task {
                // Do Search
                do {
                    try await vm.getMeals(text)
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension CategoryView {
    class ViewModel: ObservableObject {
        
        @Published var searchText = ""
        
        @Published var meals: [Meal] = .init()
        
        @Published var _categories: [Category] = .init()
 
        var categories: [Category] {
            guard !searchText.isEmpty else { return _categories }
            
            return _categories.filter { $0.strCategory.localizedCaseInsensitiveContains(searchText) }
        }
        
        
        private let network: NetworkProtocol
        
        private let context: NSManagedObjectContext
        
        init(
            network: NetworkProtocol = DefaultNetworkService.shared,
            content: NSManagedObjectContext = PersistenceController.shared.container.viewContext
        ) {
            self.network = network
            self.context = content
        }
        
        @MainActor
        func getCategories() async throws {
            let categoryRequest = CategoryRequest(apiKey: "1")
            
            let categoryResponse = try await network.request(categoryRequest)
            
            withAnimation {
                self._categories = categoryResponse.categories
            }
        }
        
        @MainActor
        func getMeals(_ name: String) async throws {
            guard name.count > 0 else {
                withAnimation {
                    self.meals = .init()
                }
                return
            }
            let mealSearchRequest = MealSearchRequest(apiKey: "1", searchText: name)
            
            if let mealsResponse = try await network.request(mealSearchRequest).meals {
                withAnimation {
                    self.meals = mealsResponse
                }
            }
        }
        
        func deleteSavedRecipe(_ entity: RecipeEntity) {
            context.delete(entity)
            try? context.save()
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
