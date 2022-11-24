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
        self.storyDetailStore.update(viewModel: viewModel)
    }
}

struct StoryDetailView: View {

    @ObservedObject var storyDetailStore = StoryDetailViewStore()
    var interactor: StoryDetailLogic?
    
    var body: some View {
        Text(storyDetailStore.displayedStory?.title ?? "")
            .onAppear {
                getStory()
            }
    }
    
    func getStory() {
        let request = StoryDetail.GetStory.Request()
        interactor?.getStory(request: request)
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView()
    }
}
