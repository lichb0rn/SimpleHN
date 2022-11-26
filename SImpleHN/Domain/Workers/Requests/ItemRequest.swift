//
//  ItemRequest.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import Foundation


///The type of item. One of "job", "story", "comment", "poll", or "pollopt".
struct ItemRequest<Model: Decodable>: Request {
    private let baseURL = "https://hacker-news.firebaseio.com/v0/item/"
    let url: URL
    
    init?(from id: Int) {
        guard let urlFromId = URL(from: id,
                                  relativeTo: baseURL,
                                  withExtension: "json") else {
            return nil
        }
        self.url = urlFromId
    }
    
    func decode(_ data: Data) throws -> Model {
        let decoder = JSONDecoder()
        return try decoder.decode(Model.self, from: data)
    }
}
