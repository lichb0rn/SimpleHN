//
//  CommentsInteractor.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 26.11.2022.
//

import Foundation


protocol CommentLogic {
    func getComments(request: Comments.GetCommentsList.Request) async
}

class CommentsInteractor {
    var presenter: CommentsPresentationLogic?
    
    private let worker: Service
    
    init(worker: Service) {
        self.worker = worker
    }
}

extension CommentsInteractor: CommentLogic {
    func getComments(request: Comments.GetCommentsList.Request) async {
        
    }
}
