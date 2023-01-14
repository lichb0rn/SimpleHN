//
//  CommentsModel.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 14.12.2022.
//

import Foundation

enum Comments {
    enum GetCommentsList {
        struct Request {
            var ids: [Int]
        }
        
        struct ReplyRequest {
            var parent: Int
        }
        
        struct Respose {
            var result: Result<[Comment], Error>
        }
        
        struct ViewModel {
            struct DisplayedComment {
                let id: Int
                let author: String
                let text: String
                let parent: Int?
                let repliesCount: String
                let timePosted: String
            }
            
            var observableComments: [ObservableComment]?
            var error: String?
            
            init(observableComments: [ObservableComment]? = nil, error: String? = nil) {
                self.observableComments = observableComments
                self.error = error
            }
        }
    }
}

extension Comments.GetCommentsList.ViewModel.DisplayedComment: Equatable {
    static func == (lhs: Comments.GetCommentsList.ViewModel.DisplayedComment, rhs: Comments.GetCommentsList.ViewModel.DisplayedComment) -> Bool {
        return lhs.id == rhs.id
    }
}


// MARK: - Preview
extension Comments.GetCommentsList.ViewModel.DisplayedComment {
    static var preview: Comments.GetCommentsList.ViewModel.DisplayedComment = {
        let comment = Comments
            .GetCommentsList
            .ViewModel
            .DisplayedComment(
                id: Comment.previewComment.id,
                author: Comment.previewComment.by,
                text: Comment.previewComment.text,
                parent: 1000,
                repliesCount: "\(Comment.previewComment.kids?.count) replies",
                timePosted: RelativeTimeFormatter.formatTimeString(timeInterval: Date.now.timeIntervalSinceNow)
                )
        return comment
    }()
}
