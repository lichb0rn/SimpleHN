//
//  CommentView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 02.12.2022.
//

import SwiftUI

struct CommentView: View {
    
    let displayedComment: Comments.GetCommentsList.ViewModel.DisplayedComment
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Text(displayedComment.author)
                    Text(displayedComment.timePosted)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                Text(displayedComment.text)
                    .font(.callout)
                
                Text(displayedComment.repliesCount)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .multilineTextAlignment(.leading)
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        let comment = Comments.GetCommentsList.ViewModel.DisplayedComment.preview
        return CommentView(displayedComment: comment)
    }
}
