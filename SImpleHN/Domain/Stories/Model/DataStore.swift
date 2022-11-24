//
//  StoriesDataStore.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI


@MainActor
class DataStore: ObservableObject {
    @Published var stories: [Stories.Fetch.ViewModel.DisplayedStory] = []
    @Published var error: String?
    
    func update(_ stories: [Stories.Fetch.ViewModel.DisplayedStory]) {
        self.stories = stories
    }
    
    func showError(_ message: String) {
        self.error = message
    }
}
