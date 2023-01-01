//
//  StoryView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI


struct StoryRowView: View {
    
    let displayedStory: Stories.Fetch.ViewModel.DisplayedStory
    
    var body: some View {
        HStack {
            Image(systemName: displayedStory.glyph.rawValue)
                .font(.title2)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(displayedStory.title)
                    .font(.headline)
                
                MetaInformationView(author: displayedStory.author,
                                    posted: displayedStory.timePosted,
                                    repliesCount: displayedStory.commentsCount,
                                    score: displayedStory.score)
                .font(.caption)
                .foregroundColor(.gray)
            }
        }
    }
}

struct StoryListRowView_Previews: PreviewProvider {
    static var previews: some View {
        let story = Story.previewStory
        return StoryRowView(displayedStory: Stories.Fetch.ViewModel.DisplayedStory(story: story, timePosted: "1 min. ago"))
    }
}
