//
//  CommentsPresenter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import Foundation

protocol CommentsPresentationLogic {
    func presentComments(response: Comments.GetCommentsList.Respose)
}

class CommentsPresenter {
    var view: CommentsDisplayLogic?
}

extension CommentsPresenter: CommentsPresentationLogic {
    @MainActor func presentComments(response: Comments.GetCommentsList.Respose) {
        var viewModel = Comments.GetCommentsList.ViewModel()
        
        switch response.result {
        case .failure(let error):
            viewModel.error = error.localizedDescription
            
        case .success(let comments):
            let displayedComments = comments.map(makeDisplayedComment(from:))
            viewModel.observableComments = displayedComments.map { ObservableComment(comment: $0)}
        }
        
        self.view?.displayComments(viewModel: viewModel)
    }
    
    private func makeDisplayedComment(from comment: Comment) -> Comments.GetCommentsList.ViewModel.DisplayedComment {
        let posted = RelativeTimeFormatter.formatTimeString(timeInterval: comment.time)
        let repliesCount = repliesCountString(from: comment.kids?.count ?? 0)
        let displayedComment = Comments
            .GetCommentsList
            .ViewModel
            .DisplayedComment(
                id: comment.id,
                author: comment.by,
                text: comment.text.htmlStrip(),
                parent: comment.parent,
                repliesCount: repliesCount,
                timePosted: posted)
        return displayedComment
    }
    
    private func repliesCountString(from value: Int) -> String {
        var str = "\(value) "
        
        var reply: String
        if value == 1 {
            reply = "reply"
        } else {
            reply = "replies"
        }
        
        str.append(reply)
        return str
    }
}
