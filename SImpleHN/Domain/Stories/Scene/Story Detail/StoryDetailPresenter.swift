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
        let story = response.story
        let timePosted = RelativeTimeFormatter.formatTimeString(timeInterval: story.time)
        let displayedStory = StoryDetail.GetStory.ViewModel.DisplayedStory(story: story,
                                                                      timePosted: timePosted)
        let viewModel = StoryDetail.GetStory.ViewModel(displayedStory: displayedStory, commentIds: story.kids)
        view?.displayStory(viewModel: viewModel)
    }
    
    func presentComments(response: StoryDetail.GetCommentsList.Respose) {
        var viewModel = StoryDetail.GetCommentsList.ViewModel(succes: false)
        
        switch response.result {
        case .failure(let error):
            viewModel.error = error.localizedDescription
        
        case .success(let comments):
            viewModel.succes = true
            viewModel.displayedComments = comments.map { comment in
                let posted = RelativeTimeFormatter.formatTimeString(timeInterval: comment.time)
                return StoryDetail.GetCommentsList.ViewModel.DisplayedComment(
                    comment: comment,
                    timePosted: posted)
            }
        }
        
        view?.displayComments(viewModel: viewModel)
    }
}
