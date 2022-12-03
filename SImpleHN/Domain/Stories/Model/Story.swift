//
//  Story.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 23.11.2022.
//

import Foundation


struct Story  {
    let id: Int
    let title: String
    let by: String
    let descendants: Int
    let kids: [Int]
    let score: Int
    let time: TimeInterval
    let link: String
    
    init(hnItem item: HNItem) {
        self.id = item.id
        self.time = item.time ?? Date().timeIntervalSinceNow
        self.by = item.by ?? ""
        self.descendants = item.descendants ?? 0
        self.kids = item.kids ?? []
        self.score = item.score ?? 0
        self.link = item.url?.absoluteString ?? ""
        self.title = item.title ?? ""
    }
}

extension Story: Identifiable {}
extension Story: Hashable {}

extension Story {
    static let previewStory = Story(hnItem: HNItem.previewItem)
}
