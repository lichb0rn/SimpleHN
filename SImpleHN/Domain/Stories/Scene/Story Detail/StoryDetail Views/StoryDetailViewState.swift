//
//  StoryDetailViewState.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.12.2022.
//

import SwiftUI

protocol StoryDetailDisplayLogic {
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel)
}

@MainActor
class StoryDetailViewState: ObservableObject {
    var interactor: StoryDetailLogic?
    
    
    @Published var storyStatus: Status<StoryDetail.GetStory.ViewModel.DisplayedStory> = .idle
    @Published var kids: [Int] = []
    
    
    init() {
        // It's probably better to start fetching from the .task {} modifier
        // But I couldn't make it work when selecting different stories in iPad
        // It looks like bug#91311311, but the ZStack workaroung wasn't working for me
        Task {
            await getStory()
        }
    }
    
    func getStory() async {
        storyStatus = .fetching
        let request = StoryDetail.GetStory.Request()
        await interactor?.getStory(request: request)
    }
}

extension StoryDetailViewState {
    enum Status<DisplayedModel: Equatable>: Equatable {
        case idle
        case fetching
        case fetched(DisplayedModel)
        case error(String)
    }
}


extension StoryDetailViewState: StoryDetailDisplayLogic {
    
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel) {
        Task {
            await MainActor.run {
                if let displayedStory = viewModel.displayedStory {
                    storyStatus = .fetched(displayedStory)
                    kids = displayedStory.kids
                } else if let error = viewModel.error {
                    storyStatus = .error(error)
                }
            }
        }
    }
}
