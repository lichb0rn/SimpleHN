//
//  CommentsListViewConfigurator.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import SwiftUI

enum CommentsListViewConfigurator {
    @MainActor
    static func commentsView(for kids: [Int], worker: Service) -> some View {
        let viewState = CommentsViewState()
        viewState.topLevelCommentIds = kids
        let view = CommentsListView(viewState: viewState)
        let interactor = CommentsInteractor(worker: worker)
        let presenter = CommentsPresenter()
        viewState.interactor = interactor
        interactor.presenter = presenter
        presenter.view = viewState
        return view
    }
}
