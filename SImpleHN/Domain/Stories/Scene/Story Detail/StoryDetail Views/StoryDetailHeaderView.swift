//
//  StoryDetailHeaderView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 28.12.2022.
//

import SwiftUI

struct StoryDetailHeaderView: View {
    
    let story: StoryDetail.GetStory.ViewModel.DisplayedStory
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(story.title)
                    .font(.body)
                    .fontWeight(.semibold)
                
                if let stroryText = story.text {
                    Text(stroryText)
                }
                
                MetaInformationView(author: story.author,
                                    posted: story.timePosted,
                                    repliesCount: story.commentsCount,
                                    score: story.score)
                .font(.caption)
            }
            
            Spacer()
        }
    }
}

struct StoryDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailHeaderView(story: StoryDetail.GetStory.ViewModel.previewDisplayedStory)
    }
}
