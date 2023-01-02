//
//  CommentView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 02.12.2022.
//

import SwiftUI

struct CommentView: View {
    
    let viewModel: StoryDetail.GetCommentsList.ViewModel.DisplayedComment
    
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Text(viewModel.author)
                    Text(viewModel.timePosted)
                }
                .font(.subheadline)
                .foregroundColor(.gray)
                
                Text(viewModel.text)
                    .font(.callout)
                
                Text(viewModel.repliesCount)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        let comment = StoryDetail.GetCommentsList.ViewModel.DisplayedComment.preview
        return CommentView(viewModel: comment)
    }
}
