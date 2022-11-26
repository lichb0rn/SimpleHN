//
//  StoryDetailRouter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import SwiftUI

protocol StoryDetailRoutingLogic {
    associatedtype View: SwiftUI.View
    func makeCommentsView()
}
