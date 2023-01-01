//
//  StoryDetailViewState.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.12.2022.
//

import SwiftUI
import Combine

protocol StoryDetailDisplayLogic {
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel)
    func displayComments(viewModel: StoryDetail.GetCommentsList.ViewModel)
}

@MainActor
class StoryDetailViewState: ObservableObject {
    var interactor: StoryDetailLogic?
    
    
    @Published var storyStatus: Status<StoryDetail.GetStory.ViewModel.DisplayedStory> = .idle
    @Published var commentsStatus: Status<[StoryDetail.GetCommentsList.ViewModel.DisplayedComment]> = .idle
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $storyStatus
            .sink { self.reduce($0) }
            .store(in: &cancellables)
            
    }
    
    private func reduce(_ status: Status<StoryDetail.GetStory.ViewModel.DisplayedStory>) {
        switch status {
        case .fetched(_):
            Task {
                await getComments()
            }
        default:
            return
        }
    }
    
    func getStory() async {
        storyStatus = .fetching
        let request = StoryDetail.GetStory.Request()
        await interactor?.getStory(request: request)
    }
    
    func getComments() async {
        commentsStatus = .fetching
        
        let request = StoryDetail.GetCommentsList.Request()
        await interactor?.getComments(request: request)
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
                } else if let error = viewModel.error {
                    storyStatus = .error(error)
                }
            }
        }
    }
    
    func displayComments(viewModel: StoryDetail.GetCommentsList.ViewModel) {
        Task {
            await MainActor.run {
                if let displayedComments = viewModel.displayedComments {
                    commentsStatus = .fetched(displayedComments)
                } else if let error = viewModel.error {
                    commentsStatus = .error(error)
                }
            }
        }
    }
    
    
}
