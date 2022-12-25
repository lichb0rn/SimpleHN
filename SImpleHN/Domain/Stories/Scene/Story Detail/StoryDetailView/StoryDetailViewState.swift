//
//  StoryDetailViewState.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.12.2022.
//

import SwiftUI

protocol StoryDetailDisplayLogic {
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel)
    func displayComments(viewModel: StoryDetail.GetCommentsList.ViewModel)
}

@MainActor
class StoryDetailViewState: ObservableObject {
    var interactor: StoryDetailLogic?
    
    @Published var story: StoryDetail.GetStory.ViewModel.DisplayedStory = .init()
    @Published var comments: [StoryDetail.GetCommentsList.ViewModel.DisplayedComment] = []
    @Published var inProgress: Bool = false
    @Published var error: String = ""
    
    func getStory() async {
        let request = StoryDetail.GetStory.Request()
        await interactor?.getStory(request: request)
    }
    
    func getComments() async {
        inProgress = true
        
        let request = StoryDetail.GetCommentsList.Request()
        await interactor?.getComments(request: request)
    }
}


extension StoryDetailViewState: StoryDetailDisplayLogic {
    
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel) {
        if let displayedStory = viewModel.displayedStory {
            self.story = displayedStory
        } else if let error = viewModel.error {
            self.error = error
        }
    }
    
    func displayComments(viewModel: StoryDetail.GetCommentsList.ViewModel) {
        inProgress = false
        if let displayedComments = viewModel.displayedComments {
            self.comments = displayedComments
        } else if let error = viewModel.error {
            self.error = error
        }
    }
    
    
}
