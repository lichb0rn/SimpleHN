//
//  StoryDetailViewStore.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

class StoryDetailViewStore: ObservableObject {
    @Published var displayedStory: StoryDetail.GetStory.ViewModel.DisplayedStory?
    
    func update(viewModel: StoryDetail.GetStory.ViewModel) {
        self.displayedStory = viewModel.displayedStory
    }
}
