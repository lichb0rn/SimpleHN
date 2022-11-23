//
//  StoryRequest.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation

struct StoryRequest: Request {
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
    
    func decode(_ data: Data) throws -> Story {
        let decoder = JSONDecoder()
        return try decoder.decode(Story.self, from: data)
    }
}
