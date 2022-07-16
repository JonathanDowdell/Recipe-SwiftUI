//
//  MealSearchRequest.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import Foundation

struct MealSearchRequest: DataRequest {
    
    var apiKey: String
    
    var url: String {
        let baseURL: String = "https://www.themealdb.com/api/json/v1"
        let path: String = "/\(apiKey)/search.php"
        return baseURL + path
    }
    
    var method: HTTPMethod = .get
    
    var headers: [String : String] = .init()
    
    var queryItems: [String : String] = .init()
    
    var decoder: JSONDecoder = .init()
    
    var encoder: JSONEncoder = .init()
    
    init(
        apiKey: String,
        searchText: String
    ) {
        self.apiKey = apiKey
        self.queryItems["s"] = searchText
    }
    
    typealias Response = MealsWrapper
    
}
