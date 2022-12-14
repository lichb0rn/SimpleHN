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
                    .navigationTitle("HN")
                    .searchable(text: $viewState.searchText, prompt: "Type to search through stories")
                    .toolbarBackground(Color("MainColor"), for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                ForEach(StoryListViewState.StoryType.allCases, id: \.self) { storyType in
                                    Button(storyType.title) {
                                        viewState.changeStoryType(to: storyType)
                                    }
                                }
                            } label: {
                                Label(viewState.requestType.title, systemImage: "chevron.down")
                                    .labelStyle(.titleAndIcon)
                            }
                        }
                    }
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
        let view = StoriesView<StoriesRouter>(viewState: viewState)
        var viewModel = Stories.Fetch.ViewModel(success: true)
        viewModel.stories = Array(repeating: .init(story: Story.previewStory,
                                                   timePosted: "2 days ago"), count: 10)
        viewState.displayStories(viewModel: viewModel)
        return view
    }
}
