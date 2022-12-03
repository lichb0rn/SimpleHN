//
//  StoryView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

struct StoryViewModel {
    let id: Int
    let title: String
    let score: String
    let author: String
    let commentsCount: String
    let timePosted: String
    let link: String?
}

struct StoryHeaderView: View {
    
    let viewModel: StoryViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.title)
                .font(.headline)
            
            MetaInforamtionView(score: viewModel.score,
                                author: viewModel.author,
                                posted: viewModel.timePosted,
                                commentsCount: viewModel.commentsCount)
            .font(.caption)
            .foregroundColor(.gray)
        }
    }
}

struct StoryListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let story = Story.previewStory
        let previewViewModel = StoryViewModel(id: story.id,
                                              title: story.title,
                                              score: String(story.score),
                                              author: story.by,
                                              commentsCount: String(story.descendants),
                                              timePosted: "1 min. ago",
                                              link: "(theverge.com)")
        return StoryHeaderView(viewModel: previewViewModel)
    }
}
