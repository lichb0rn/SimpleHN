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
}
