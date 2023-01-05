//
//  StoryDetailRouter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import SwiftUI

protocol StoryDetailRoutingLogic {
    associatedtype View: SwiftUI.View
    @ViewBuilder func makeCommentsView(for kids: [Int]) -> View
}

class StoryDetailRouter: StoryDetailRoutingLogic {
    
    @MainActor @ViewBuilder
    func makeCommentsView(for kids: [Int]) -> some View {
        CommentsListViewConfigurator.commentsView(for: kids, worker: NetworkService())
    }
}
