//
//  StoryDetailViewStore.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

@MainActor
class StoryDetailViewStore: ObservableObject {
    private var viewModel: StoryDetail.GetStory.ViewModel? = nil
    
    @Published var story: StoryDetail.GetStory.ViewModel.DisplayedStory = .init()
    @Published var error: String? = nil
    @Published var comments: [StoryDetail.GetCommentsList.ViewModel.DisplayedComment] = []
    
    
    func update(viewModel: StoryDetail.GetStory.ViewModel) {
        if let displayedStory = viewModel.displayedStory {
            self.story = displayedStory
        } else if let error = viewModel.error {
            self.error = error
        }
        self.viewModel = viewModel
    }
    
    func addComments(viewModel: StoryDetail.GetCommentsList.ViewModel) {
        if let displayedComments = viewModel.displayedComments {
            self.comments = displayedComments
        }
    }
}
