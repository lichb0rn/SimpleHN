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
                headerSection
                    .padding(.horizontal)
                Divider()
            }
            .background(Color("MainColor"))
            .task {
                await viewState.getComments()
            }
            
            Group {
                if !viewState.inProgress {
                    CommentsListView(data: viewState.comments, children: \.replies) { reply in
                        CommentView(viewModel: reply)
                    }
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            
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
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewState.story.title)
                    .font(.body)
                    .fontWeight(.semibold)
                
                MetaInforamtionView(author: viewState.story.author,
                                    posted: viewState.story.timePosted,
                                    repliesCount: viewState.story.commentsCount,
                                    score: viewState.story.score)
                .font(.caption)
            }
            
            Spacer()
        }
    }
    
    func getStory() async {
        let request = StoryDetail.GetStory.Request()
        await interactor?.getStory(request: request)
    }
    
    func getComments() async {
        let request = StoryDetail.GetCommentsList.Request()
        await interactor?.getComments(request: request)
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
