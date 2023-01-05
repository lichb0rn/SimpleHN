//
//  StoryDetailView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

struct StoryDetailView<Router: StoryDetailRoutingLogic>: View {
    var router: Router?
    
    @ObservedObject var viewState: StoryDetailViewState
    
    @State private var id = 0
    
    var body: some View {
        VStack {
            VStack {
                renderStoryState(viewState.storyStatus)
                Divider()
            }
            .padding(.vertical)
            
            Group {
                if !viewState.kids.isEmpty {
                    router?.makeCommentsView(for: viewState.kids)
                } else {
                    Text("No comments yet")
                    Spacer()
                }
            }
        }
        .toolbarBackground(Color("MainColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .id(id)
        .task {
            await viewState.getStory()
        }
        .refreshable {
            await viewState.getStory()
            id += 1
        }
    }
    
    private func renderStoryState(_ state: StoryDetailViewState.Status<StoryDetail.GetStory.ViewModel.DisplayedStory>) -> some View {
        Group {
            switch state {
            case .idle:
                Text("Nothing to show")
            case .fetching:
                ProgressView()
            case .fetched(let displayedStory):
                StoryDetailHeaderView(story: displayedStory)
                    .padding(.horizontal)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if let link = displayedStory.link {
                                Link(destination: link) {
                                    Image(systemName: "globe")
                                }
                            }
                        }
                    }
            case .error(let msg):
                Text(msg)
            }
        }
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = StoryDetail.GetStory.ViewModel.previewViewModel
        let viewState = StoryDetailViewState()
        viewState.displayStory(viewModel: viewModel)
        let view = StoryDetailView<StoryDetailRouter>(viewState: viewState)
        return view
    }
}
