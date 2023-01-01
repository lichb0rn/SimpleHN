//
//  StoryDetailPresenter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

protocol StoryDetailPresentationLogic {
    func presentStory(response: StoryDetail.GetStory.Response)
    func presentComments(response: StoryDetail.GetCommentsList.Respose)
}

class StoryDetailPresenter {
    var view: StoryDetailDisplayLogic?
}

extension StoryDetailPresenter: StoryDetailPresentationLogic {
    @MainActor func presentStory(response: StoryDetail.GetStory.Response) {
        var viewModel = StoryDetail.GetStory.ViewModel()
        switch response.result {
        case .failure(let error):
            viewModel.error = error.localizedDescription
            
        case .success(let story):
            let timePosted = RelativeTimeFormatter.formatTimeString(timeInterval: story.time)
            let displayedStory = StoryDetail.GetStory.ViewModel.DisplayedStory(story: story,
                                                                               timePosted: timePosted)
            viewModel.displayedStory = displayedStory
        }
        
        view?.displayStory(viewModel: viewModel)
    }
    
    @MainActor func presentComments(response: StoryDetail.GetCommentsList.Respose) {
        var viewModel = StoryDetail.GetCommentsList.ViewModel()
        
        switch response.result {
        case .failure(let error):
            viewModel.error = error.localizedDescription
            
        case .success(let comments):
            viewModel.displayedComments = buildCommentTree(comments)
        }
        
        self.view?.displayComments(viewModel: viewModel)
    }
    
    private func buildCommentTree(_ comments: [Comment]) -> [StoryDetail.GetCommentsList.ViewModel.DisplayedComment] {
        var tree: [StoryDetail.GetCommentsList.ViewModel.DisplayedComment] = []
        
        for comment in comments {
            var displayed = makeDisplayedComment(from: comment)
            
            if !comment.replies.isEmpty {
                displayed.replies = buildCommentTree(comment.replies)
            }
            
            tree.append(displayed)
        }
        return tree
    }
    
    private func makeDisplayedComment(from comment: Comment) -> StoryDetail.GetCommentsList.ViewModel.DisplayedComment {
        let posted = RelativeTimeFormatter.formatTimeString(timeInterval: comment.time)
        let repliesCount = repliesCountString(from: comment.replies.count)
        let commentText = htmlStrip(comment.text)
        let displayedComment = StoryDetail
            .GetCommentsList
            .ViewModel
            .DisplayedComment(
                id: comment.id,
                author: comment.by,
                text: commentText,
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
    
    private func htmlStrip(_ html: String) -> String {
        let data = Data(html.utf8)
        if let nsAttrString = try? NSAttributedString(data: data,
                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                      documentAttributes: nil) {
            return nsAttrString.string
        } else {
            return html
        }
    }
}
