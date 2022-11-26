//
//  StoryDetailInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation


protocol StoryDetailLogic {
    func getStory(request: StoryDetail.GetStory.Request) async
}

class StoryDetailInteractor {
    var presenter: StoryDetailPresentationLogic?
    let story: Story
    
    private let worker: Service
    
    init(story: Story, worker: Service) {
        self.story = story
        self.worker = worker
    }
}

extension StoryDetailInteractor: StoryDetailLogic {
    func getStory(request: StoryDetail.GetStory.Request) async {
        let response = StoryDetail.GetStory.Response(story: story)
        presenter?.presentStory(response: response)
    }
}
