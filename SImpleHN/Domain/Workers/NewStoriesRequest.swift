//
//  NewStoriesRequest.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation

struct NewStoriesRequest: Request {
    var url: URL {
        let baseURL = "https://hacker-news.firebaseio.com/v0/newstories.json"
        guard let url = URL(string: baseURL) else { preconditionFailure("Something wrong with the base url") }
        return url
    }
    
    func decode(_ data: Data) throws -> [Story.ID] {
        let decoder = JSONDecoder()
        let topStories = try decoder.decode([Story.ID].self, from: data)
        return topStories
    }
}


