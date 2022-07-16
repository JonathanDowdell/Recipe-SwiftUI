//
//  CategoryView.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import SwiftUI
import NukeUI

struct CategoryView: View {
    
    @StateObject private var vm = ViewModel()
    
    @StateObject var delayedTextSearch = DelayedTextObject()
    
    @Environment(\.isSearching) var isSearching
    
    @Environment(\.dismissSearch) var dismissSearch
    
    var body: some View {
        NavigationView {
            List {
                // Meals
                if vm.meals.count > 0 {
                    Section {
                        ForEach(vm.meals, id: \.self) { meal in
                            NavigationLink {
                                RecipeView(meal: meal)
                            } label: {
                                MealCategoryItem(meal: meal)
                            }
                        }
                    } header: {
                        Text("Meals")
                    }
                }
                
                // Favorites
                
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
        
        @Published var _categories: [Category] = .init()
 
        var categories: [Category] {
            guard !searchText.isEmpty else { return _categories }
            
            return _categories.filter { $0.strCategory.localizedCaseInsensitiveContains(searchText) }
        }
        
        @Published var meals: [Meal] = .init()
        
        
        private let network: NetworkProtocol
        
        init(
            network: NetworkProtocol = DefaultNetworkService.shared
        ) {
            self.network = network
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
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView()
    }
}
