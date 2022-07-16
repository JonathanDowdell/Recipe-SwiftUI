//
//  CategoryItem.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import SwiftUI
import NukeUI

struct CategoryItem: View {
    
    var category: Category
    
    var body: some View {
        HStack {
            LazyImage(source: category.strCategoryThumb, resizingMode: .aspectFit)
                .frame(width: 40, height: 40, alignment: .center)
                .cornerRadius(10)
            
            Text(category.strCategory)
                .font(.title3)
                .padding(.leading)
        }
    }
}

struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                NavigationLink {
                    EmptyView()
                } label: {
                    CategoryItem(category: Category.MOCK)
                }
            }
            .navigationTitle("Recipe")
        }
    }
}
