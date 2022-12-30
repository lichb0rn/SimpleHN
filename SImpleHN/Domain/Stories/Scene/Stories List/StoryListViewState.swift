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


@MainActor
class StoryListViewState: ObservableObject {
    var interactor: StoriesLogic?
    
    private var currentRequest = Stories.Fetch.Request(type: .top)
    
    @Published var requestType: Stories.Fetch.Request.RequestType = .top {
        didSet {
            currentRequest = Stories.Fetch.Request(type: requestType)
            Task {
                
            }
        }
    }
    @Published var status = Status.idle
    
    func getStories() async {
        let request = currentRequest
        await interactor?.fetch(request: request)
        status = .fetching
    }
}


extension StoryListViewState {
    enum Status: Equatable {
        case idle
        case fetching
        case fetched([Stories.Fetch.ViewModel.DisplayedStory])
        case error(String)
    }
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


