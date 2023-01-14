//
//  CommentsInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import Foundation

protocol CommentsLogic {
    func getComments(request: Comments.GetCommentsList.Request) async
    func getCommentReplies(request: Comments.GetCommentsList.ReplyRequest) async
}

class CommentsInteractor {
    var presenter: CommentsPresentationLogic?
    
    private let worker: Service
    
    init(worker: Service) {
        self.worker = worker
    }
}


extension CommentsInteractor: CommentsLogic {
    func getComments(request: Comments.GetCommentsList.Request) async {
        let idsToFetch = request.ids
        guard !idsToFetch.isEmpty else {
            presentEmpty()
            return
        }
        
        do {
            let comments = try await fetchComments(withIds: idsToFetch)
            presentComments(comments)
        } catch {
            presentError(error)
        }
    }
    
    func getCommentReplies(request: Comments.GetCommentsList.ReplyRequest) async {
        guard let parent = try? await worker.fetch(by: request.parent),
              let replies = parent.kids,
              !replies.isEmpty else {
            return
        }
        
        do {
            let comments = try await fetchComments(withIds: replies)
            presentComments(comments)
        } catch {
            presentError(error)
        }
    }
    
    private func presentEmpty() {
        let emptyResponse = Comments.GetCommentsList.Respose(result: .success([]))
        presenter?.presentComments(response: emptyResponse)
    }
    
    private func presentComments(_ comments: [Comment]) {
        let response = Comments.GetCommentsList.Respose(result: .success(comments))
        presenter?.presentComments(response: response)
    }
    
    private func presentError(_ error: Error) {
        let errorResponse = Comments.GetCommentsList.Respose(result: .failure(error))
        presenter?.presentComments(response: errorResponse)
    }
    
    private func fetchComments(withIds ids: [Int]) async throws-> [Comment] {
        guard !ids.isEmpty else { return [] }
        
        var comments: [Comment] = []
        let items = try await worker.fetch(by: ids)
        let filterDeleted = items.filter({ $0.deleted == nil })
        comments = filterDeleted.map(Comment.init)
    
        return comments
    }
}
