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
                if let displayedComments = viewModel.displayedComments {
                    status = .fetched(displayedComments)
                } else if let error = viewModel.error {
                    status = .error(error)
                }
            }
        }
    }
}


class CommentsViewState: ObservableObject {
    var interactor: CommentsLogic?
    
    @Published var status: Status<[Comments.GetCommentsList.ViewModel.DisplayedComment]> = .idle
    
    var topLevelCommentIds: [Int] = []

    
    
    @MainActor
    func getComments() async {
        guard !topLevelCommentIds.isEmpty else { return }
        status = .fetching
        
        let request = Comments.GetCommentsList.Request(ids: topLevelCommentIds)
        await interactor?.getComments(request: request)
    }

    func getComment(for parent: Int) async {

    }
}


extension CommentsViewState {
    enum Status<DisplayedModel: Equatable>: Equatable {
        case idle
        case fetching
        case fetched(DisplayedModel)
        case error(String)
    }
}
