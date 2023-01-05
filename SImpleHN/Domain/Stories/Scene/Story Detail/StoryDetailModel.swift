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
            var result: Result<Story, Error>
        }
        
        struct ViewModel {
            struct DisplayedStory: Identifiable, Equatable {
                let id: Int
                let title: String
                let score: String
                let author: String
                let commentsCount: String
                let timePosted: String
                let text: String?
                let link: URL?
                let kids: [Int]
                
                init(story: Story, timePosted: String) {
                    self.id = story.id
                    self.title = story.title
                    self.score = "\(story.score)"
                    self.author = story.by
                    self.commentsCount = "\(story.descendants)"
                    self.timePosted = timePosted
                    self.link = URL(string: story.link)
                    self.text = story.text?.htmlStrip()
                    self.kids = story.kids ?? []
                }
                
                init() {
                    id = -1
                    title = ""
                    score = ""
                    author = ""
                    commentsCount = ""
                    timePosted = ""
                    link = nil
                    text = nil
                    kids = []
                }
            }
            
            var displayedStory: DisplayedStory?
            var error: String?
            
            init(displayedStory: DisplayedStory? = nil, error: String? = nil) {
                self.displayedStory = displayedStory
                self.error = error
            }
        }
    }
}

extension StoryDetail.GetStory.ViewModel {
    static var previewViewModel: StoryDetail.GetStory.ViewModel = {
        var viewModel = StoryDetail.GetStory.ViewModel()
        viewModel.displayedStory = previewDisplayedStory
        return viewModel
    }()
    
    static var previewDisplayedStory: StoryDetail.GetStory.ViewModel.DisplayedStory = {
        let story = StoryDetail.GetStory.ViewModel.DisplayedStory(
            story: Story.previewStory,
            timePosted: RelativeTimeFormatter.formatTimeString(timeInterval: Story.previewStory.time)
        )
        return story
    }()
}


