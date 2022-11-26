//
//  StoryDetailModel.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

enum StoryDetail {
    enum GetStory {
        struct Request {}
        
        struct Response {
            var story: Story
        }
        
        struct ViewModel {
            struct DisplayedStory: Identifiable, Hashable {
                let id: Int
                var title: String
                let score: String
                let author: String
                let commentsCount: String
                let timePosted: String
                
                init(story: Story, timePosted: String) {
                    self.id = story.id
                    self.title = story.title
                    self.score = "\(story.score)"
                    self.author = story.by
                    self.commentsCount = "\(story.descendants)"
                    self.timePosted = timePosted
                }
                init() {
                    id = -1
                    title = ""
                    score = ""
                    author = ""
                    commentsCount = ""
                    timePosted = ""
                }
            }
            
            var displayedStory: DisplayedStory
            var commentIds: [Int]
        }
    }
}
