//
//  StoryDetailView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

protocol StoryDetailDisplayLogic {
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel)
}

extension StoryDetailView: StoryDetailDisplayLogic {
    func displayStory(viewModel: StoryDetail.GetStory.ViewModel) {
        Task {
            await MainActor.run {
                self.store.update(viewModel: viewModel)
            }
        }
    }
}

struct StoryDetailView: View {

    @ObservedObject var store = StoryDetailViewStore()
    var interactor: StoryDetailLogic?
    
    var body: some View {
        StoryView(viewModel: store.viewModel)
            .task {
                await getStory()
            }
            .id(store.viewModel.id)
    }
    
    func getStory() async{
        let request = StoryDetail.GetStory.Request()
        await interactor?.getStory(request: request)
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel: StoryDetail
            .GetStory
            .ViewModel = .init(
                displayedStory: .init(story: Story.previewStory,
                                      timePosted: RelativeTimeFormatter.formatTimeString(timeInterval: Story.previewStory.time)),
                commentIds: [123, 321, 123])
        
        let previewStore = StoryDetailViewStore()
        previewStore.update(viewModel: viewModel)
        
        return StoryDetailView(store: previewStore)
    }
}
