//
//  Seeds.swift
//  SImpleHNTests
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation
@testable import SImpleHN

enum Seeds {
    static let stories: [Story] = [Seeds.story]
    
    static let story: Story = Story(id: 9129911,
                                    title: "Venture Capital in the 1980s",
                                    by: "theyeti",
                                    descendants: 16,
                                    score: 78,
                                    time: 1425261906,
                                    url: URL(string: "http://reactionwheel.net/2015/01/80s-vc.html")!
    )
    
//    static let topStoriesData = Data("[91229911]".utf8)
//    
//    static let storyData = Data("""
//            {
//              "by": "theyeti",
//              "descendants": 16,
//              "id": 9129911,
//              "kids": [
//                9129990,
//                9130206,
//                9130376,
//                9130273,
//                9131289,
//                9131728,
//                9137773,
//                9132476
//              ],
//              "score": 78,
//              "text": "",
//              "time": 1425261906,
//              "title": "Venture Capital in the 1980s",
//              "type": "story",
//              "url": "http://reactionwheel.net/2015/01/80s-vc.html"
//            }
//            """.utf8)
}
