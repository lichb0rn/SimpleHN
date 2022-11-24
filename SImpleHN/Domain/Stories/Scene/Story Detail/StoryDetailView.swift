//
//  StoryDetailView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import SwiftUI

struct StoryDetailView: View {
    
    let story: Story
    
    var body: some View {
        Text(story.title)
    }
}

struct StoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoryDetailView(story: Story.previewStory)
    }
}
