//
//  StoriesRouter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

protocol StoriesRoutingLogic {
    associatedtype View: SwiftUI.View
    @ViewBuilder func makeDetailView() -> View
}

class StoriesRouter: StoriesRoutingLogic {
    
    @ViewBuilder
    func makeDetailView() -> some View {
        
    }
}
