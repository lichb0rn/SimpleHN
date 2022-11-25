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
        self.store.update(viewModel: viewModel)
    }
}

struct StoryDetailView: View {

    @ObservedObject var store = StoryDetailViewStore()
    var interactor: StoryDetailLogic?
    
    var body: some View {
        StoryView(viewModel: store.viewModel)
            .onAppear {
                getStory()
            }
            .id(store.viewModel.id)
    }
    
    func getStory() {
        let request = StoryDetail.GetStory.Request()
        interactor?.getStory(request: request)
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let previewStore = StoryDetailViewStore()
        previewStore.update(viewModel: .init(displayedStory: .init(story: Story.previewStory,
                                                                   timePosted: RelativeTimeFormatter.formatTimeString(timeInterval: Story.previewStory.time))))
        return StoryDetailView(store: previewStore)
    }
}
