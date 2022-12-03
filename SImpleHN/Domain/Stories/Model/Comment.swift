//
//  Comment.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 25.11.2022.
//

import Foundation


struct Comment  {
    let by: String
    let id: Int
    let kids: [Int]
    let parent: Int?
    let text: String
    let time: TimeInterval
    
    init(hnItem item: HNItem) {
        self.by = item.by ?? ""
        self.id = item.id
        self.kids = item.kids ?? []
        self.parent = item.parent
        self.text = item.text ?? ""
        self.time = item.time ?? Date().timeIntervalSinceNow
    }
}

extension Comment: Identifiable {}
extension Comment: Hashable {}


extension Comment {
    static let previewComment: Comment = Comment(hnItem: HNItem.previewItem)
}
