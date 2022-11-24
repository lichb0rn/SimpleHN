//
//  StoriesListView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

struct StoriesListView: View {
    
    var stories: [Stories.Fetch.ViewModel.DisplayedStory]
    @Binding var selectedStory: Stories.Fetch.ViewModel.DisplayedStory.ID?
    
    var body: some View {
        List(stories, selection: $selectedStory) { story in
            StoryListRowView(title: story.title,
                             score: story.score,
                             commentsCount: story.commentsCount,
                             timePosted: story.timePosted)
            .listRowBackground(Color("RowBackgroundColor"))
        }
        .listStyle(.plain)
    }
}

struct StoriesListView_Previews: PreviewProvider {
    fileprivate typealias ViewModel = Stories.Fetch.ViewModel
    static let viewModel = ViewModel.previewViewModel()
    static var previews: some View {
        return StoriesListView(stories: viewModel.stories ?? [], selectedStory: .constant(nil))
    }
}
