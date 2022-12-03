//
//  StoriesConfigurator.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

enum StoriesViewConfigurator {
    static func storiesView() -> some View {
        var view = StoriesView<StoriesRouter>()
        let interactor = StoriesInteractor(worker: NetworkService())
        let presenter = StoriesPresenter()
        let router = StoriesRouter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        view.router = router
        router.store = interactor
        return view
    }
}
