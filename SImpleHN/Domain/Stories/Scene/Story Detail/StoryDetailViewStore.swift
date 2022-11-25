//
//  StoryDetailViewStore.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

class StoryDetailViewStore: ObservableObject {
    @Published var story: StoryDetail.GetStory.ViewModel.DisplayedStory = .init()
    
    func update(viewModel: StoryDetail.GetStory.ViewModel) {
        story = viewModel.displayedStory
    }
}
