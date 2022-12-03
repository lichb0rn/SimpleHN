//
//  CommentView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 02.12.2022.
//

import SwiftUI

struct CommentView: View {
    
    let viewModel: Comments.GetCommentsList.ViewModel.DisplayedComment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 12) {
                Text(viewModel.author)
                Text(viewModel.timePosted)
            }
            .font(.headline)
            .foregroundColor(.gray)
            
            Text(viewModel.text)
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(
            viewModel:
                Comments.GetCommentsList.ViewModel.DisplayedComment(
                    id: Comment.previewComment.id,
                    author: Comment.previewComment.by,
                    answers: [],
                    text: Comment.previewComment.text,
                    timePosted: RelativeTimeFormatter.formatTimeString(timeInterval: Comment.previewComment.time)
                )
        )
    }
}
