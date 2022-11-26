//
//  StoryDetailViewStore.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

@MainActor
class StoryDetailViewStore: ObservableObject {
    @Published var viewModel: StoryViewModel = .init(id: -1, title: "", score: "", author: "", commentsCount: "", timePosted: "", link: nil)
    
    func update(viewModel: StoryDetail.GetStory.ViewModel) {
        let displayedViewModel = StoryViewModel(id: viewModel.displayedStory.id,
                                                title: viewModel.displayedStory.title,
                                                score: viewModel.displayedStory.score,
                                                author: viewModel.displayedStory.author,
                                                commentsCount: viewModel.displayedStory.commentsCount,
                                                timePosted: viewModel.displayedStory.timePosted,
                                                link: nil)
        self.viewModel = displayedViewModel
    }
}
