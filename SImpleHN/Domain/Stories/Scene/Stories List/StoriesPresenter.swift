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
        var viewModel = Stories.Fetch.ViewModel(success: false)
        
        if let stories = response.stories {
            viewModel.stories = stories.map { story in
                let posted = RelativeTimeFormatter.formatTimeString(timeInterval: story.time)
                
                return Stories.Fetch.ViewModel
                    .DisplayStory(story: story,
                                  timePosted: posted)
            }
            viewModel.success = true
        } else {
            viewModel.errorMessage = response.error?.localizedDescription
        }
        
        view?.displayStories(viewModel: viewModel)
    }
}
