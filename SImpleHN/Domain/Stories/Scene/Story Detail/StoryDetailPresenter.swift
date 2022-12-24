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
    func presentStory(response: StoryDetail.GetStory.Response) {
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
    
    func presentComments(response: StoryDetail.GetCommentsList.Respose) {
        let viewModel = StoryDetail.GetCommentsList.ViewModel()
        
        switch response.result {
        case .failure(let error):
            viewModel.error = error.localizedDescription
        
        case .success(let comments):
            viewModel.displayedComments = buildCommentTree(comments)
        }
        
        view?.displayComments(viewModel: viewModel)
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
        let displayedComment = StoryDetail
            .GetCommentsList
            .ViewModel
            .DisplayedComment(
                id: comment.id,
                author: comment.by,
                text: comment.text,
                parent: comment.parent,
                repliesCount: comment.replies.count,
                timePosted: posted)
        return displayedComment
    }
}
