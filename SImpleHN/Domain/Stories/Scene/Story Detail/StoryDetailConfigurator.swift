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
        let view = StoryDetailView(viewState: viewState)
        let interactor = StoryDetailInteractor(story: story, worker: worker)
        let presenter = StoryDetailPresenter()
        viewState.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewState
        return view
    }
}
