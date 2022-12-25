//
//  StoriesView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI


struct StoriesView<Router: StoriesRoutingLogic>: View {
    
    @ObservedObject var viewState: StoryListViewState
    
    var router: Router?
    
    @State private var selected: Story.ID?
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
            renderState(viewState.status)
                .navigationTitle("HN")
                .toolbarBackground(Color("MainColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        } detail: {
            if let selected {
                router?.makeDetailView(for: selected)
            } else {
                Text("Select a story")
            }
        }
        .task {
            await viewState.getStories()
        }
    }
    
    @ViewBuilder
    private func renderState(_ state: StoryListViewState.Status) -> some View {
        Group {
            switch state {
            case .idle:
                StartupView()
            case .fetching:
                ProgressView()
            case .error(let error):
                Text(error)
            case .fetched(let stories):
                StoriesListView(stories: stories, selectedStory: $selected)
                    .refreshable {
                        await viewState.getStories()
                    }
            }
        }
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let viewState = StoryListViewState()
        return StoriesView<StoriesRouter>(viewState: viewState)
    }
}
