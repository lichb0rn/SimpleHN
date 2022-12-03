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
            struct DisplayedStory: Identifiable, Hashable {
                let id: Int
                var title: String
                let score: String
                let author: String
                let commentsCount: String
                let timePosted: String
                let url: String?
                
                init(story: Story, timePosted: String) {
                    self.id = story.id
                    self.title = story.title
                    self.score = "\(story.score)"
                    self.author = "\(story.by)"
                    self.commentsCount = "\(story.descendants)"
                    self.timePosted = timePosted
                    self.url = story.link
                }
            }
            
            var stories: [DisplayedStory]?
            var success: Bool
            var errorMessage: String?
        }
    }
}

extension Stories.Fetch.ViewModel {
    static func previewViewModel() -> Stories.Fetch.ViewModel {
        var vm = Stories.Fetch.ViewModel(success: true)
        vm.stories = []
        for _ in 0..<30 {
            vm.stories?.append(DisplayedStory(story: Story.previewStory,
                                              timePosted: RelativeTimeFormatter.relativeTime(fromInterval: Double.random(in: 1...100),
                                                                                             relativeTo: .now) ))
        }
        return vm
    }
}
