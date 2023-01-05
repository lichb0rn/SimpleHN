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
    var story: Story
    
    private let worker: Service
    
    init(story: Story, worker: Service) {
        self.story = story
        self.worker = worker
    }
}

extension StoryDetailInteractor: StoryDetailLogic {
    func getStory(request: StoryDetail.GetStory.Request) async {
        let response = await fetchStory(self.story)
        presenter?.presentStory(response: response)
    }
    
    private func fetchStory(_ story: Story) async -> StoryDetail.GetStory.Response {
        do {
            let hnItem = try await worker.fetch(by: story.id)
            let story = Story(hnItem: hnItem)
            self.story = story
            let response = StoryDetail.GetStory.Response(result: .success(story))
            return response
        } catch {
            let errorResponse = StoryDetail.GetStory.Response(result: .failure(error))
            return errorResponse
        }
    }
}
