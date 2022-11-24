//
//  StoriesView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

protocol StoriesDisplayLogic {
    func displayStories(viewModel: Stories.Fetch.ViewModel)
}

extension StoriesView: StoriesDisplayLogic {
    func displayStories(viewModel: Stories.Fetch.ViewModel) {
        Task {
            await MainActor.run {
                if viewModel.success, let stories = viewModel.stories {
                    storiesDataStore.update(stories)
                } else if let errorMessage = viewModel.errorMessage {
                    storiesDataStore.showError(errorMessage)
                }
            }
        }
    }
}

struct StoriesView<Router: StoriesRoutingLogic>: View {
    
    @ObservedObject var storiesDataStore = DataStore()
    
    var interactor: StoriesLogic?
    var router: Router?
    
    @State private var selected: Story.ID?
    
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.doubleColumn)) {
            StoriesListView(stories: storiesDataStore.stories, selectedStory: $selected)
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
            await self.fetch()
        }
    }
    
    func fetch() async {
        let request = Stories.Fetch.Request()
        await interactor?.fetch(request: request)
    }
}

struct StoriesView_Previews: PreviewProvider {
    static var previewStore:DataStore = {
        let store = DataStore()
        store.update(Stories.Fetch.ViewModel.previewViewModel().stories ?? [])
        return store
    }()
    static var previews: some View {
        return StoriesView<StoriesRouter>(storiesDataStore: previewStore)
    }
}
