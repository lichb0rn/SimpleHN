//
//  CommentsInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import Foundation

protocol CommentsLogic {
    func getComments(request: Comments.GetCommentsList.Request) async
}

class CommentsInteractor {
    var presenter: CommentsPresentationLogic?
    
    
    private var comments: [Comment] = []
    private let worker: Service
    
    init(worker: Service) {
        self.worker = worker
    }
}


extension CommentsInteractor: CommentsLogic {
    func getComments(request: Comments.GetCommentsList.Request) async {
        let idsToFetch = request.ids
        guard !idsToFetch.isEmpty else {
            let emptyResponse = Comments.GetCommentsList.Respose(result: .success([]))
            presenter?.presentComments(response: emptyResponse)
            return
        }
        
        do {
            let comments = try await fetchComments(withIds: request.ids)
            let response = Comments.GetCommentsList.Respose(result: .success(comments))
            presenter?.presentComments(response: response)
        } catch {
            let errorResponse = Comments.GetCommentsList.Respose(result: .failure(error))
            presenter?.presentComments(response: errorResponse)
        }
    }
    
    private func fetchComments(withIds ids: [Int]) async throws-> [Comment] {
        guard !ids.isEmpty else { return [] }
        
        var comments: [Comment] = []
        let items = try await worker.fetch(by: ids)
        let filterDeleted = items.filter({ $0.deleted == nil })
        comments = filterDeleted.map(Comment.init)
        
        for idx in comments.indices {
            if let kids = comments[idx].kids {
                let replies = try await fetchComments(withIds: kids)
                comments[idx].addReplies(replies)
            }
        }
        return comments
    }
}
