//
//  StoryDetailConfigurator.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

enum StoryDetailConfigurator {
    @MainActor
    static func storyDetail(for story: Story, worker: Service) -> some View {
        let viewState = StoryDetailViewState()
        var view = StoryDetailView<StoryDetailRouter>(viewState: viewState)
        let interactor = StoryDetailInteractor(story: story, worker: worker)
        let presenter = StoryDetailPresenter()
        let router = StoryDetailRouter()
        viewState.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewState
        view.router = router
        return view
    }
}
