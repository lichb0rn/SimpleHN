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
        self.store.update(viewModel: viewModel)
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
        
    var body: some View {
        ScrollView(.vertical) {
            StoryHeaderView(viewModel: store.storyViewModel)
                .frame(maxWidth: .infinity, alignment: .leading)
                .task {
                    await getComments()
                }
            
            LazyVStack {
                ForEach(store.commentViewModels) { comment in
                    Text(comment.text)
                }
            }
        }
        .padding()
        .onAppear {
            getStory()
        }
    }
    
    func getStory() {
        let request = StoryDetail.GetStory.Request()
        interactor?.getStory(request: request)
    }
    
    func getComments() async {
        let request = StoryDetail.GetCommentsList.Request()
        await interactor?.getComments(request: request)
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel: StoryDetail
            .GetStory
            .ViewModel = .init(
                displayedStory: .init(story: Story.previewStory,
                                      timePosted:
                                        RelativeTimeFormatter.formatTimeString(
                                            timeInterval: Story.previewStory.time)),
                commentIds: [123, 321, 246])
        
        let previewStore = StoryDetailViewStore()
        previewStore.update(viewModel: viewModel)
        
        return StoryDetailView(store: previewStore)
    }
}
