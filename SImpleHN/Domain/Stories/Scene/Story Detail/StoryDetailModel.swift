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
    
    enum GetCommentsList {
        struct Request {}
        
        struct Respose {
            var result: Result<[Comment], Error>
        }
        
        struct ViewModel {
            struct DisplayedComment: Identifiable {
                let id: Int
                let author: String
                let answers: [Comment]
                let text: String
                let timePosted: String
                
                init(comment: Comment, timePosted: String) {
                    self.id = comment.id
                    self.author = comment.by
                    self.answers = []
                    self.text = comment.text
                    self.timePosted = timePosted
                }
            }
            
            var succes: Bool
            var displayedComments: [DisplayedComment]?
            var error: String?
        }
    }
}
