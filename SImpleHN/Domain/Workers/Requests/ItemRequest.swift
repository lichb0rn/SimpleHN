//
//  ItemRequest.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import Foundation


///The type of item. One of "job", "story", "comment", "poll", or "pollopt".
struct ItemRequest<DTO: Decodable>: Request {
    private let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/item/")!
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    init(id: Int) {
        let component = String(id).appending(".json")
        self.url = baseURL.appending(component: component)
    }
    
    func decode(_ data: Data) throws -> DTO {
        let decoder = JSONDecoder()
        return try decoder.decode(DTO.self, from: data)
    }
}
