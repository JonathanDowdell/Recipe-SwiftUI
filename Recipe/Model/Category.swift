//
//  Category.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import Foundation

struct CategoryWrapper: Codable {
    var categories: [Category] = .init()
}

extension CategoryWrapper: Hashable {}

struct Category: Codable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    let strCategoryDescription: String
}

extension Category: Hashable {}

extension Category {
    static let MOCK = Category(idCategory: "1", strCategory: "Beef", strCategoryThumb: "https://www.themealdb.com/images/category/beef.png", strCategoryDescription: "Beef is the culinary name for meat from cattle, particularly skeletal muscle. Humans have been eating beef since prehistoric times.[1] Beef is a source of high-quality protein and essential nutrients.[2]")
}
