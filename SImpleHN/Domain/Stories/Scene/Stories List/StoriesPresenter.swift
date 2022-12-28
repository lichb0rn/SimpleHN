//
//  StoriesPresenter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

protocol StoriesPresentationLogic {
    func presentStories(response: Stories.Fetch.Response)
}

class StoriesPresenter {
    var view: StoriesDisplayLogic?
}

extension StoriesPresenter: StoriesPresentationLogic {
    
    func presentStories(response: Stories.Fetch.Response) {
        var viewModel = Stories.Fetch.ViewModel(success: true)
        
        if let stories = response.stories {
            viewModel.stories = stories.map { story in
                let posted = RelativeTimeFormatter.formatTimeString(timeInterval: story.time)
                
                return Stories.Fetch.ViewModel
                    .DisplayedStory(story: story,
                                  timePosted: posted)
            }
        } else {
            viewModel.errorMessage = response.error?.localizedDescription
        }
        
        view?.displayStories(viewModel: viewModel)
    }
}
