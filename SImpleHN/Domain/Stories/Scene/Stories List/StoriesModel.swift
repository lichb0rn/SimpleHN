//
//  StoriesModel.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 24.11.2022.
//

import Foundation

enum Stories {
    enum Fetch {
        struct Request {}
        
        struct Response {
            var stories: [Story]?
            var error: Error?
        }
        
        struct ViewModel {
            struct DisplayStory: Identifiable, Hashable {
                let id: Int
                var title: String
                let score: String
                let author: String
                let commentsCount: String
                let timePosted: String
                
                init(story: Story, timePosted: String) {
                    self.id = story.id
                    self.title = story.title
                    self.score = "\(story.score) points"
                    self.author = story.by
                    self.commentsCount = "\(story.descendants) comments"
                    self.timePosted = timePosted
                }
            }
            
            var stories: [DisplayStory]?
            var success: Bool
            var errorMessage: String?
        }
    }
}
