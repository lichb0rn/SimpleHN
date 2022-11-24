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

struct StoriesView: View {
    
    @ObservedObject var storiesDataStore = StoriesDataStore()
    
    var interactor: StoriesLogic?
    
    @State private var selected: Story.ID?
    
    var body: some View {
        NavigationSplitView {
            StoriesListView(stories: storiesDataStore.stories, selectedStory: $selected)
                .navigationTitle("HN")
                .toolbarBackground(Color("MainColor"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        } detail: {
            Text("Select a story")
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
    static var previewStore:StoriesDataStore = {
        let store = StoriesDataStore()
        store.update(Stories.Fetch.ViewModel.previewViewModel().stories ?? [])
        return store
    }()
    static var previews: some View {
        return StoriesView(storiesDataStore: previewStore)
    }
}
