//
//  StoriesDataStore.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

protocol StoriesDisplayLogic {
    func displayStories(viewModel: Stories.Fetch.ViewModel)
}

extension StoryListViewState: StoriesDisplayLogic {
    func displayStories(viewModel: Stories.Fetch.ViewModel) {
        Task {
            await MainActor.run {
                if viewModel.success, let displayedStories = viewModel.stories {
                    status = .fetched(displayedStories)
                } else if let error = viewModel.errorMessage {
                    status = .error(error)
                }
            }
        }
    }
}

@MainActor
class StoryListViewState: ObservableObject {
    var interactor: StoriesLogic?
    
    @Published private(set) var status = Status.idle
    @Published private(set) var requestType = StoryType.new {
        didSet {
            Task { await getStories() }
        }
    }
        
    
    func getStories() async {
        let request = requestType.request
        status = .fetching
        await interactor?.fetch(request: request)
    }
    
    func changeStoryType(to type: StoryType) {
        self.requestType = type
    }
}


extension StoryListViewState {
    enum Status: Equatable {
        case idle
        case fetching
        case fetched([Stories.Fetch.ViewModel.DisplayedStory])
        case error(String)
    }
    
    enum StoryType: CaseIterable {
        case new
        case top
        
        var title: String {
            switch self {
            case .new: return "New"
            case .top: return "Top"
            }
        }
    }
}


fileprivate extension StoryListViewState.StoryType {
    var request: Stories.Fetch.Request {
        switch self {
        case .new:
            return Stories.Fetch.Request(type: .new)
        case .top:
            return Stories.Fetch.Request(type: .top)
        }
    }
}




