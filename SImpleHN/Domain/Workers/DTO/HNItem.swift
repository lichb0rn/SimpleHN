//
//  BaseDTO.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 30.11.2022.
//

import Foundation

//https://hackernews.api-docs.io/v0/items/base
/// HackerNews API item (DTO)
struct HNItem: Decodable {
    /// All HN items share two common keys, others are optonal
    /// So I declared all the keys for Story and Comment here
    /// Then pass to a proper model in init
    
    // Common keys
    let id: Int
    let type: ItemType
    
    let by: String?
    let time: TimeInterval?
    let kids: [Int]?
    var deleted: Bool? = nil
    var dead: Bool? = nil
    
    
    // Story
    let title: String?
    let descendants: Int?
    let score: Int?
    let url: URL?
    
    // Comment
    let parent: Int?
    let text: String?
}

extension HNItem {
    enum ItemType: String, CustomStringConvertible, Decodable {
        case job = "job"
        case story = "story"
        case comment = "comment"
        case poll = "poll"
        case pollopt = "pollopt"
        
        var description: String { rawValue }
    }
}


extension HNItem {
    static let previewItem = HNItem(id: 1000,
                                    type: .story,
                                    by: "theyeti",
                                    time: 1425261906,
                                    kids: [1001, 1002],
                                    title: "Venture Capital in the 1980s",
                                    descendants: 100,
                                    score: 100,
                                    url: URL(string: "http://reactionwheel.net/2015/01/80s-vc.html")!,
                                    parent: 999,
                                    text: "Aw shucks, guys ... you make me blush with your compliments.<p>Tell you what, Ill make a deal: I'll keep writing if you keep reading. K?")
}
