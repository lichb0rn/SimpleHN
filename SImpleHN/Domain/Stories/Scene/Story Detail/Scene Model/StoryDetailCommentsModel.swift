//
//  StoryDetailCommentsModel.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 14.12.2022.
//

import Foundation

extension StoryDetail {
    enum GetCommentsList {
        struct Request { }
        
        struct Respose {
            var result: Result<[Comment], Error>
        }
        
        class ViewModel {
            struct DisplayedComment: Identifiable {
                let id: Int
                let author: String
                let text: String
                let parent: Int?
                let repliesCount: Int
                let timePosted: String
                var replies: [StoryDetail.GetCommentsList.ViewModel.DisplayedComment]? = nil
            }
            
            var displayedComments: [DisplayedComment]?
            var error: String?
            
            init(displayedComments: [DisplayedComment]? = nil, error: String? = nil) {
                self.displayedComments = displayedComments
                self.error = error
            }
        }
    }
}

extension StoryDetail.GetCommentsList.ViewModel.DisplayedComment: Equatable {
    static func == (lhs: StoryDetail.GetCommentsList.ViewModel.DisplayedComment, rhs: StoryDetail.GetCommentsList.ViewModel.DisplayedComment) -> Bool {
        return lhs.id == rhs.id
    }
}


// MARK: - Preview
extension StoryDetail.GetCommentsList.ViewModel.DisplayedComment {
    static var preview: StoryDetail.GetCommentsList.ViewModel.DisplayedComment = {
        let comment = StoryDetail
            .GetCommentsList
            .ViewModel
            .DisplayedComment(
                id: Comment.previewComment.id,
                author: Comment.previewComment.by,
                text: Comment.previewComment.text,
                parent: 1000,
                repliesCount: Comment.previewComment.replies.count,
                timePosted: RelativeTimeFormatter.formatTimeString(timeInterval: Date.now.timeIntervalSinceNow)
                )
        return comment
    }()
}
