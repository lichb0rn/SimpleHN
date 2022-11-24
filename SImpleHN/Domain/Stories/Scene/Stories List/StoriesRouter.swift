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

protocol StoriesDataPassing {
    var store: StoriesStore? { get set }
}

class StoriesRouter: StoriesRoutingLogic, StoriesDataPassing {
    var store: StoriesStore?
    
    func makeDetailView(for id: Stories.Fetch.ViewModel.DisplayedStory.ID) -> StoryDetailView {
        let story = store?.stories?.first(where: { $0.id == id })
        let detailView = StoryDetailConfigurator.storyDetail(for: story!)
        return detailView as! StoryDetailView
    }
}
