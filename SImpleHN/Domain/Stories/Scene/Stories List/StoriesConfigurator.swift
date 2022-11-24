//
//  StoriesConfigurator.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

enum StoriesViewConfigurator {
    static func storiesView() -> some View {
        var view = StoriesView()
        let interactor = StoriesInteractor()
        let presenter = StoriesPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}
