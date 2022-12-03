//
//  CommentsPresenter.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import Foundation

protocol CommentsPresentationLogic {
    func presentComments(response: Comments.GetCommentsList.Respose)
}

class CommentsPresenter {
    var view: CommentsDisplayLogic?
}


extension CommentsPresenter: CommentsPresentationLogic {
    func presentComments(response: Comments.GetCommentsList.Respose) {
        
    }
}
