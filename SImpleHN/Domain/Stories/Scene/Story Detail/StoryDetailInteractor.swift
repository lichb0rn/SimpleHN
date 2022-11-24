//
//  StoryDetailInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation


protocol StoryDetailLogic {
    func getStory(request: StoryDetail.GetStory.Request)
}

class StoryDetailInteractor {
    var presenter: StoryDetailPresentationLogic?
    let story: Story
    
    init(story: Story) {
        self.story = story
    }
}

extension StoryDetailInteractor: StoryDetailLogic {
    func getStory(request: StoryDetail.GetStory.Request) {
        let response = StoryDetail.GetStory.Response(story: story)
        presenter?.presentStory(response: response)
    }
}
