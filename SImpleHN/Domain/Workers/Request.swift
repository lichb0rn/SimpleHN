//
//  Request.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation

protocol Request {
    associatedtype Output
    func decode(_ data: Data) throws -> Output
    
    var url: URL { get }
}

extension Request where Output: Decodable {
    func decode(_ data: Data) throws -> Output {
        let decoder = JSONDecoder()
        return try decoder.decode(Output.self, from: data)
    }
}
