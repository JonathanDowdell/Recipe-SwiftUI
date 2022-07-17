//
//  MealsCategoryView.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import SwiftUI

struct MealsCategoryView: View {
    
    @StateObject var vm: ViewModel = .init()
    
    let category: Category
    
    var body: some View {
        List {
            ForEach(vm.meal, id: \.self) { meal in
                NavigationLink {
                    RecipeView(vm: .init(meal: meal))
                } label: {
                    MealCategoryItem(meal: meal)
                }
            }

        }
        .navigationTitle(category.strCategory)
        .searchable(text: $vm.searchText)
        .task {
            await vm.getMeals(category: category.strCategory)
        }
    }
}

struct MealsCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        MealsCategoryView(category: .MOCK)
    }
}

extension MealsCategoryView {
    class ViewModel: ObservableObject {
        
        @Published var searchText: String = ""
        
        @Published var _meal: [Meal] = .init()
        
        var meal: [Meal] {
            guard !searchText.isEmpty else { return _meal }
            return self._meal.filter {
                $0.strMeal.localizedCaseInsensitiveContains(searchText)||$0.idMeal.contains(searchText)
            }
        }
        
        private let network: NetworkProtocol
        
        init(
            network: NetworkProtocol = DefaultNetworkService.shared
        ) {
            self.network = network
        }
        
        @MainActor
        func getMeals(category: String) async {
            let mealRequest = MealsRequest(apiKey: "1", category: category)
            do {
                if let meals = try await network.request(mealRequest).meals {
                    withAnimation {
                        self._meal = meals
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}
