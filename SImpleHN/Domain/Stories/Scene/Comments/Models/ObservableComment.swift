//
//  TreeNode.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 14.01.2023.
//

import SwiftUI


// Simple observable tree with level-order searching
class ObservableComment: ObservableObject, Identifiable {
    
    var id: Int {
        displayedComment.id
    }

    @Published private(set) var displayedComment: Comments.GetCommentsList.ViewModel.DisplayedComment
    @Published private(set) var replies: [ObservableComment]?
    
    init(comment: Comments.GetCommentsList.ViewModel.DisplayedComment, replies: [ObservableComment]? = nil) {
        self.displayedComment = comment
        self.replies = replies
    }
    
    func addReplies(_ replies: [ObservableComment]) -> Bool {
        guard let parentId = replies.first?.displayedComment.parent else { return false }
        
        if let parentComment = breadFirstSearch(parentId: parentId) {
            parentComment.replies = replies
            return true
        }
        
        return false
    }
    
    
    private func breadFirstSearch(parentId: Int) -> ObservableComment? {
        if self.id == parentId {
            return self
        }
        
        guard let children = self.replies else { return nil }
        
        var queue = [ObservableComment]()
        children.forEach { queue.append($0) }
        
        while !queue.isEmpty {
            let node = queue.removeFirst()
            if node.displayedComment.id == parentId {
                return node
            }
            node.replies?.forEach { queue.append($0) }
        }
        
        return nil
    }
}


extension ObservableComment: Equatable {
    static func == (lhs: ObservableComment, rhs: ObservableComment) -> Bool {
        lhs.id == rhs.id
    }
}
