//
//  NetworkProtocol.swift
//  Recipe
//
//  Created by Mettaworldj on 7/15/22.
//

import Foundation

protocol NetworkProtocol {
    func request<Request: DataRequest>(_ request: Request) async throws -> Request.Response
}
