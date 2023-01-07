//
//  StoriesRouter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

protocol StoriesRoutingLogic {
    associatedtype View: SwiftUI.View
    func makeDetailView(for id: Stories.Fetch.ViewModel.DisplayedStory.ID) -> View
}

class StoriesRouter: StoriesRoutingLogic {
    var store: StoriesStore?
    
    @MainActor
    @ViewBuilder
    func makeDetailView(for id: Stories.Fetch.ViewModel.DisplayedStory.ID) -> some View {
        if let story = store?.stories?.first(where: { $0.id == id }) {
            StoryDetailConfigurator.storyDetail(for: story, worker: NetworkService())
        }
    }
}
