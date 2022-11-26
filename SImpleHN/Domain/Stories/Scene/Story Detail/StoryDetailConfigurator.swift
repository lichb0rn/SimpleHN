//
//  StoryDetailConfigurator.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

enum StoryDetailConfigurator {
    static func storyDetail(for story: Story, worker: Service) -> some View {
        var view = StoryDetailView()
        let interactor = StoryDetailInteractor(story: story, worker: worker)
        let presenter = StoryDetailPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}
