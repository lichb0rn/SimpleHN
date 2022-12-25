//
//  StoriesConfigurator.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

enum StoriesViewConfigurator {
    @MainActor static func storiesView() -> some View {
        let viewState = StoryListViewState()
        var view = StoriesView<StoriesRouter>(viewState: viewState)
        let interactor = StoriesInteractor(worker: NetworkService())
        let presenter = StoriesPresenter()
        let router = StoriesRouter()
        interactor.presenter = presenter
        presenter.view = viewState
        view.router = router
        viewState.interactor = interactor
        router.store = interactor
        return view
    }
}
