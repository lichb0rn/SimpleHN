//
//  StoryDetailView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

struct StoryDetailView: View {
    @ObservedObject var viewState: StoryDetailViewState
    var interactor: StoryDetailLogic?
    
    @State private var id = 0
    
    var body: some View {
        VStack {
            VStack {
                renderStoryState(viewState.storyStatus)
                Divider()
                    .padding(.horizontal)
            }
            .background(Color("MainColor"))
            
            renderCommentsState(viewState.commentsStatus)
        }
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
    
    private func renderCommentsState(_ state: StoryDetailViewState.Status
                                     <[StoryDetail.GetCommentsList.ViewModel.DisplayedComment]>) -> some View {
        Group {
            switch state {
            case .idle:
                Text("Nothing to show")
            case .fetching:
                Spacer()
                ProgressView()
                Spacer()
            case .fetched(let displayedComments):
                CommentsListView(data: displayedComments, children: \.replies) { reply in
                    CommentView(viewModel: reply)
                }
            case .error(let msg):
                Text(msg)
            }
        }
    }
    
    
    func getStory() async {
        let request = StoryDetail.GetStory.Request()
        await interactor?.getStory(request: request)
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = StoryDetail.GetStory.ViewModel.previewViewModel
        
        let commentsViewModel: StoryDetail
            .GetCommentsList
            .ViewModel = .init(displayedComments:
                                [StoryDetail.GetCommentsList.ViewModel.DisplayedComment.preview]
            )
        
        let viewState = StoryDetailViewState()
        let view = StoryDetailView(viewState: viewState)
        viewState.displayStory(viewModel: viewModel)
        viewState.displayComments(viewModel: commentsViewModel)
        
        return view
    }
}
