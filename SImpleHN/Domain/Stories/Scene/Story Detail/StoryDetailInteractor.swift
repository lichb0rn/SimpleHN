//
//  StoryDetailInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation


protocol StoryDetailLogic {
    func getStory(request: StoryDetail.GetStory.Request) async
    func getComments(request: StoryDetail.GetCommentsList.Request) async
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
    
    func getComments(request: StoryDetail.GetCommentsList.Request) async {
        guard let kids = self.story.kids else {
            let emptyResponse = StoryDetail.GetCommentsList.Respose(result: .success([]))
            presenter?.presentComments(response: emptyResponse)
            return
        }
        
        do {
            let comments = try await fetchComments(withIds: kids)
            let response = StoryDetail.GetCommentsList.Respose(result: .success(comments))
            presenter?.presentComments(response: response)
        } catch {
            let errorResponse = StoryDetail.GetCommentsList.Respose(result: .failure(error))
            presenter?.presentComments(response: errorResponse)
        }
    }
    
    private func fetchComments(withIds ids: [Int]) async throws-> [Comment] {
        guard !ids.isEmpty else { return [] }
        
        var comments: [Comment] = []
        let items = try await worker.fetch(by: ids)
        comments = items.map(Comment.init)
        
        for idx in comments.indices {
            if let kids = comments[idx].kids {
                let replies = try await fetchComments(withIds: kids)
                comments[idx].addReplies(replies)
            }
        }
        return comments
    }
    
}
