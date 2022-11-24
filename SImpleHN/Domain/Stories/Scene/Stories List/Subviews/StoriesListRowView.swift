//
//  StoriesListRowView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

struct StoryListRowView: View {
    
    let title: String
    let score: String
    let commentsCount: String
    let timePosted: String
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            Text(timePosted)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Text(score)
                Text(commentsCount)
                Spacer()
            }
            .font(.caption)
            .foregroundColor(.gray)
        }
    }
}

struct StoryListRowView_Previews: PreviewProvider {
    static var previews: some View {
        
        StoryListRowView(title: "PR that converts the TypeScript repo from namespaces to modules",
                     score: "315 points",
                     commentsCount: "170 comments",
                     timePosted: "Posted 1 minute ago")
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
