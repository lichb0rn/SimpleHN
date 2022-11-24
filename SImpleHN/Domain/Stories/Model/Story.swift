//
//  Story.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation

struct Story: Codable {
    let id: Int
    let title: String
    let by: String
    let descendants: Int
    let score: Int
    let time: TimeInterval
    let url: URL
}

extension Story: Identifiable {}
extension Story: Hashable {}


extension Story {
    static var previewStory = Story(id: Int.random(in: 1000...999999),
                                    title: "Venture Capital in the 1980s",
                                    by: "theyeti",
                                    descendants: Int.random(in: 0...100),
                                    score: Int.random(in: 0...100),
                                    time: 1425261906,
                                    url: URL(string: "http://reactionwheel.net/2015/01/80s-vc.html")!)
}
