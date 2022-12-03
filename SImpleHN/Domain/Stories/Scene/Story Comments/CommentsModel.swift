//
//  CommentsModel.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 02.12.2022.
//

import Foundation

enum Comments {
    enum GetCommentsList {
        struct Request {}
        
        struct Respose {
            var comments: [Comments]
        }
        
        struct ViewModel {
            struct DisplayedComment: Identifiable {
                let id: Int
                let author: String
                let answers: [Comment]
                let text: String
                let timePosted: String
            }
            
            var displayedComments: [Comment]
        }
    }
}
