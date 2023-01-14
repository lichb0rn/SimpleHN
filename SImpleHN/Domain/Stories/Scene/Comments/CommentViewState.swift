//
//  CommentViewState.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 05.01.2023.
//

import Foundation

protocol CommentsDisplayLogic {
    func displayComments(viewModel: Comments.GetCommentsList.ViewModel)
}

extension CommentsViewState: CommentsDisplayLogic {
    func displayComments(viewModel: Comments.GetCommentsList.ViewModel) {
        Task {
            await MainActor.run {
                if let comments = viewModel.observableComments {
                    status = .fetched
                    merge(with: comments)
                } else if let error = viewModel.error {
                    status = .error(error)
                }
            }
        }
    }
}


class CommentsViewState: ObservableObject {
    enum Status: Equatable {
        case idle
        case fetching
        case fetched
        case error(String)
    }
    
    var interactor: CommentsLogic?
    
    @Published private(set) var status: Status = .idle
    @Published private(set) var comments: [ObservableComment] = []
    
    var topLevelCommentIds: [Int] = []
    
    @MainActor
    func getComments() async {
        guard !topLevelCommentIds.isEmpty else { return }
        status = .fetching
        
        let request = Comments.GetCommentsList.Request(ids: topLevelCommentIds)
        await interactor?.getComments(request: request)
    }
    
    func getComment(for parent: Int) async {
        let request = Comments.GetCommentsList.ReplyRequest(parent: parent)
        await interactor?.getCommentReplies(request: request)
    }
    
    private func merge(with new: [ObservableComment]) {
        guard !comments.isEmpty else {
            self.comments = new
            return
        }
        
        comments.forEach {  if $0.addReplies(new) { return } }
    }
}
