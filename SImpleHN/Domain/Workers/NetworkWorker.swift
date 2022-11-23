//
//  NetworkWorker.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation

protocol Networking {
    func fetch<R: Request>(_ request: R) async throws -> R.Output
    func fetch<T: Decodable>(fromURL url: URL) async throws -> T
}


struct NetworkWorker: Networking {
    let session: URLSession = URLSession.shared
    
    private let successCodes = (200...299)

    func fetch<R: Request>(_ request: R) async throws -> R.Output {
        let urlRequest = URLRequest(url: request.url)
        let (data, response) = try await session.data(for: urlRequest)
            
        if !isValidResponse(response) {
            throw NetworkError.badServerResponse
        }

        return try request.decode(data)
    }
    
    func fetch<T>(fromURL url: URL) async throws -> T where T : Decodable {
        let (data, response) = try await session.data(from: url)
        
        if !isValidResponse(response) {
            throw NetworkError.badServerResponse
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    private func isValidResponse(_ response: URLResponse) -> Bool {
        if let httpResponse = response as? HTTPURLResponse,
           successCodes.contains(httpResponse.statusCode)  {
            return true
        } else {
            return false
        }
    }
}
