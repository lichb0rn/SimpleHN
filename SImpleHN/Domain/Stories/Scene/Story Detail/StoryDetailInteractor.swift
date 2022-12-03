//
//  StoryDetailInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation


protocol StoryDetailLogic {
    func getStory(request: StoryDetail.GetStory.Request)
    func getComments(request: StoryDetail.GetCommentsList.Request) async
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
    func getStory(request: StoryDetail.GetStory.Request) {
        let response = StoryDetail.GetStory.Response(story: story)
        presenter?.presentStory(response: response)
    }
    
    func getComments(request: StoryDetail.GetCommentsList.Request) async {
        let commentIdsToFetch = story.kids
        do {
            let hnItems = try await worker.fetch(by: commentIdsToFetch)
            print(hnItems)
            let comments = hnItems.map(Comment.init)
            let response = StoryDetail.GetCommentsList.Respose(result: .success(comments))
            presenter?.presentComments(response: response)
        } catch {
            let errorResponse = StoryDetail.GetCommentsList.Respose(result: .failure(error))
            presenter?.presentComments(response: errorResponse)
        }
    }
}
