//
//  StoryDetailRouter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import SwiftUI

protocol StoryDetailRoutingLogic {
    associatedtype View: SwiftUI.View
    func makeWebView(for url: URL) -> View
}

class StoryDetailRouter: StoryDetailRoutingLogic {
    
    func makeWebView(for url: URL) -> some View {
        return EmptyView()
    }
}
