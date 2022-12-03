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
            let viewModel = StoryViewModel(id: story.id,
                                           title: story.title,
                                           score: story.score,
                                           author: story.author,
                                           commentsCount: story.commentsCount,
                                           timePosted: story.timePosted,
                                           link: story.url)
            StoryHeaderView(viewModel: viewModel)
                .padding(.vertical, 4)
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
