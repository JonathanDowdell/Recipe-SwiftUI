//
//  DefaultNetworkService.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import Foundation

final class DefaultNetworkService: NetworkProtocol {
    
    static let shared = DefaultNetworkService()
    
    func request<Request: DataRequest>(_ request: Request) async throws -> Request.Response {
        guard var urlComponent = URLComponents(string: request.url) else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )
            
            throw error
        }
        
        let queryItems = request.queryItems.map {
            return URLQueryItem(name: $0.key, value: $0.value)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            let error = NSError(
                domain: ErrorResponse.invalidEndpoint.rawValue,
                code: 404,
                userInfo: nil
            )
            
            throw error
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let response = response as? HTTPURLResponse else {
            let error = NSError(domain: ErrorResponse.invalidResponse.rawValue, code: -1, userInfo: nil)
            throw error
        }
        
        guard 200..<300 ~= response.statusCode else {
            let error = NSError(domain: ErrorResponse.invalidStatusCode.rawValue, code: response.statusCode, userInfo: nil)
            throw error
        }
        
        return try request.decode(data)
    }
}
