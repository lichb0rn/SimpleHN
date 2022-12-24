//
//  StoryDetailView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

protocol StoryDetailDisplayLogic {
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel)
    func displayComments(viewModel: StoryDetail.GetCommentsList.ViewModel)
}

extension StoryDetailView: StoryDetailDisplayLogic {
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel) {
        Task {
            await MainActor.run {
                self.store.update(viewModel: viewModel)
            }
        }
    }
    
    func displayComments(viewModel: StoryDetail.GetCommentsList.ViewModel) {
        Task {
            await MainActor.run {
                self.store.addComments(viewModel: viewModel)
            }
        }
    }
}


struct StoryDetailView: View {
    
    @ObservedObject var store = StoryDetailViewStore()
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
                await getComments()
            }


            CommentsListView(data: store.comments, children: \.replies) { reply in
                CommentView(viewModel: reply)
            }
        }
        .id(id)
        .task {
            await getStory()
        }
        .refreshable {
            await getStory()
            id += 1
        }
    }
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(store.story.title)
                    .font(.body)
                    .fontWeight(.semibold)
                
                MetaInforamtionView(author: store.story.author,
                                    posted: store.story.timePosted,
                                    repliesCount: store.story.commentsCount,
                                    score: store.story.score)
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
        
        let previewStore = StoryDetailViewStore()
        previewStore.update(viewModel: viewModel)
        previewStore.addComments(viewModel: commentsViewModel)
        
        return StoryDetailView(store: previewStore)
    }
}
