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
        if viewModel.success, let stories = viewModel.stories {
            storiesDataStore.update(stories)
        } else if let errorMessage = viewModel.errorMessage {
            storiesDataStore.showError(errorMessage)
        }
    }
}

struct StoriesView: View {
    
    @ObservedObject var storiesDataStore = StoriesDataStore()
    
    var interactor: StoriesLogic?
    
    @State private var selected: Story.ID?
    
    var body: some View {
        NavigationSplitView {
            StoriesListView()
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
    static var previews: some View {
        StoriesView()
    }
}
