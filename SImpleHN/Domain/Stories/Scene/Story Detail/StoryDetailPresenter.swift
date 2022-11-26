//
//  StoryDetailPresenter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

protocol StoryDetailPresentationLogic {
    func presentStory(response: StoryDetail.GetStory.Response)
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
}
